```@meta
CurrentModule = Oscar.GRDB
```

# Graded Ring Database

This module provides read access to the [Graded Ring Database (GRDB)](https://grdb.co.uk),
which is served by the key-value database of the
Parallel Computational Algebra System (PCAS) at `fanosearch.net`.
Communication uses gRPC via [gRPCClient.jl](https://github.com/JuliaIO/gRPCClient.jl).

The server holds several databases, each consisting of tables.
Every record of a table is a dictionary with the same keys.
The functions below mirror the interface of the [OscarDB](@ref) module,
but are not exported; call them as `Oscar.GRDB.get_db` etc.

## Example

```julia
julia> c = Oscar.GRDB.get_db("smooth_toric")["smooth_toric"]
GRDB table smooth_toric in database smooth_toric

julia> length(c, Dict("dimension" => 6))
7622

julia> r = Oscar.GRDB.find_one(c, Dict("dimension" => 6, "Fano_index" => 7));

julia> r["degree"]
117649
```

## Functions

```@docs
list_databases
get_db
get_collection_names
find
find_one
length(::Collection, ::AbstractDict)
```
