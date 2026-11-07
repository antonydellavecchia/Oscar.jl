module GRDB

import gRPCClient: gRPCChannel
import ProtoBuf: OneOf

# Generated from ../proto by ../proto/generate.jl, do not edit by hand
include("gen/kvdb/kvdb.jl")

using .kvdb: Kvdb

const Empty = kvdb.google.protobuf.Empty
const CondType = kvdb.var"Condition.CondType"
const LeafType = kvdb.var"LeafOperator.LeafType"
const ValueType = kvdb.var"Value.Type"

const GRDB_HOST = "fanosearch.net"
const GRDB_PORT = 12356
# Public certificate of the self-signed PCAS CA, trusted only for GRDB connections
const GRDB_CA_ROOTS = joinpath(@__DIR__, "fanocert.pem")

"""
    Database

Type for referencing a database on the Graded Ring Database (GRDB) server.
"""
struct Database
  chan::gRPCChannel
  name::String
end

"""
    Collection

Type for referencing a table in a [`Database`](@ref Oscar.GRDB.Database).
"""
struct Collection
  db::Database
  name::String
end

_metadata(db::Database) = Dict("db_name" => db.name)
_metadata(c::Collection) = Dict("db_name" => c.db.name, "table_name" => c.name)

_channel(host::AbstractString, port::Integer) =
  gRPCChannel(host, port; secure=true, ca_roots=GRDB_CA_ROOTS)

################################################################################
# Conversion between Julia values and kvdb messages

# Bool is checked before Integer since Bool <: Integer
_value(x::Bool) = kvdb.Value(ValueType.BOOL, OneOf(:bool_value, x))
_value(x::Integer) = kvdb.Value(ValueType.INT64, OneOf(:int64_value, Int64(x)))
_value(x::AbstractFloat) = kvdb.Value(ValueType.FLOAT64, OneOf(:double_value, Float64(x)))
_value(x::AbstractString) = kvdb.Value(ValueType.STRING, OneOf(:string_value, String(x)))
_value(x::Vector{UInt8}) = kvdb.Value(ValueType.BYTESLICE, OneOf(:bytes_value, x))

_julia_value(v::kvdb.Value) = isnothing(v.value) ? nothing : v.value[]

_parse_record(r::kvdb.Record) =
  Dict{String, Any}(k => _julia_value(v) for (k, v) in r.values)

# A key equal to a value gives an equality test, a key equal to a range gives
# an (inclusive) BETWEEN test. Several pairs are combined with AND, an empty
# Dict matches everything.
function _condition(key::AbstractString, value)
  leaf = kvdb.LeafOperator(key, LeafType.EQ, _value(value))
  return kvdb.Condition(CondType.LEAF, OneOf(:leaf_value, leaf))
end

function _condition(key::AbstractString, r::AbstractUnitRange)
  between = kvdb.LhsLowerUpper(key, _value(first(r)), _value(last(r)))
  return kvdb.Condition(CondType.BETWEEN, OneOf(:lhs_lower_upper_value, between))
end

function _condition(d::AbstractDict)
  isempty(d) && return kvdb.Condition(CondType.BOOL, OneOf(:bool_value, true))
  length(d) == 1 && return _condition(only(d)...)
  conds = [_condition(k, v) for (k, v) in d]
  return kvdb.Condition(CondType.AND, OneOf(:many_conditions_value, kvdb.ManyConditions(conds)))
end

_order(keys::Vector{String}) =
  kvdb.OrderBy([kvdb.Order(k, kvdb.Direction(false)) for k in keys])

################################################################################
# Queries

@doc raw"""
    list_databases(; host="fanosearch.net", port=12356)

Return the names of the databases on the GRDB server.
"""
list_databases(; host::AbstractString=GRDB_HOST, port::Integer=GRDB_PORT) =
  Kvdb.ListDatabases(_channel(host, port), Empty()).name

@doc raw"""
    get_db(name::AbstractString; host="fanosearch.net", port=12356)

Return the database `name` on the GRDB server. Its tables are accessed with
`db[table_name]`.

# Examples
```julia
julia> db = Oscar.GRDB.get_db("smooth_toric");

julia> Oscar.GRDB.get_collection_names(db)
1-element Vector{String}:
 "smooth_toric"
```
"""
get_db(name::AbstractString; host::AbstractString=GRDB_HOST, port::Integer=GRDB_PORT) =
  Database(_channel(host, port), String(name))

Base.getindex(db::Database, name::AbstractString) = Collection(db, String(name))

@doc raw"""
    get_collection_names(db::Database)

Return the names of the tables in `db`.
"""
get_collection_names(db::Database) =
  Kvdb.ListTables(db.chan, Empty(); metadata=_metadata(db)).name

# Record with all keys of the table, used as template for the returned records
_template(c::Collection) = Kvdb.DescribeTable(c.db.chan, Empty(); metadata=_metadata(c))

@doc raw"""
    length(c::Collection, d::Dict=Dict())

Return the number of records in `c` matching `d`, see [`find`](@ref Oscar.GRDB.find)
for the format of `d`.
"""
Base.length(c::Collection, d::AbstractDict=Dict()) =
  Int(Kvdb.CountWhere(c.db.chan, _condition(d); metadata=_metadata(c)).n)

@doc raw"""
    find(c::Collection, d::Dict=Dict(); limit::Int=-1, sort_by::Vector{String}=String[])

Return the records of `c` matching `d` as a vector of `Dict{String, Any}`.
Each pair `key => value` of `d` requires the record to have `value` at `key`,
a pair `key => a:b` requires the value at `key` to lie in `a:b`. A negative
`limit` returns all matching records. The records are sorted ascending by the
keys in `sort_by`.

# Examples
```julia
julia> c = Oscar.GRDB.get_db("smooth_toric")["smooth_toric"];

julia> rs = Oscar.GRDB.find(c, Dict("dimension" => 6, "Picard_rank" => 1); limit=3);

julia> length(rs)
3

julia> rs[1]["Fano_index"]
7
```
"""
function find(c::Collection, d::AbstractDict=Dict(); limit::Int=-1, sort_by::Vector{String}=String[])
  req = kvdb.ConditionTemplateOrderAndLimit(_condition(d), _template(c), _order(sort_by), limit)
  # ponytail: collects the whole stream into memory, return a lazy iterator if results get large
  return [_parse_record(r) for r in Kvdb.SelectWhereLimit(c.db.chan, req; metadata=_metadata(c))]
end

@doc raw"""
    find_one(c::Collection, d::Dict=Dict(); sort_by::Vector{String}=String[])

Return the first record of `c` matching `d`, or `nothing` if there is none.
See [`find`](@ref Oscar.GRDB.find) for the arguments.
"""
function find_one(c::Collection, d::AbstractDict=Dict(); sort_by::Vector{String}=String[])
  req = kvdb.ConditionTemplateAndOrder(_condition(d), _template(c), _order(sort_by))
  res = Kvdb.SelectOneWhere(c.db.chan, req; metadata=_metadata(c))
  return res.has_record ? _parse_record(res.record) : nothing
end

Base.show(io::IO, db::Database) = print(io, "GRDB database ", db.name)
Base.show(io::IO, c::Collection) = print(io, "GRDB table ", c.name, " in database ", c.db.name)

end # module GRDB
