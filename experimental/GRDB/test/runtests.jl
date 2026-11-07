import ProtoBuf as PB

# Values, conditions and records survive a protobuf encode/decode roundtrip,
# and the live queries work when the GRDB server is reachable
@testset "GRDB" begin
  GRDB = Oscar.GRDB
  kvdb = GRDB.kvdb

  function roundtrip(x)
    io = IOBuffer()
    PB.encode(PB.ProtoEncoder(io), x)
    seekstart(io)
    return PB.decode(PB.ProtoDecoder(io), typeof(x))
  end

  @testset "Values" begin
    for x in (true, 7, -3, 2.5, "abc", UInt8[1, 2, 3])
      @test GRDB._julia_value(roundtrip(GRDB._value(x))) == x
    end
    @test GRDB._value(true).var"#type" == GRDB.ValueType.BOOL
    @test GRDB._value(1).var"#type" == GRDB.ValueType.INT64

    r = kvdb.Record(Dict("id" => GRDB._value(8635), "vertices" => GRDB._value("[[1,0],[0,1]]")))
    @test GRDB._parse_record(roundtrip(r)) == Dict{String, Any}("id" => 8635, "vertices" => "[[1,0],[0,1]]")
  end

  @testset "Conditions" begin
    c = roundtrip(GRDB._condition(Dict()))
    @test c.var"#type" == GRDB.CondType.BOOL
    @test c.value[] == true

    c = roundtrip(GRDB._condition(Dict("dimension" => 6)))
    @test c.var"#type" == GRDB.CondType.LEAF
    @test c.value[].lhs == "dimension"
    @test c.value[].opcode == GRDB.LeafType.EQ
    @test GRDB._julia_value(c.value[].rhs) == 6

    c = roundtrip(GRDB._condition(Dict("dimension" => 4:6)))
    @test c.var"#type" == GRDB.CondType.BETWEEN
    @test GRDB._julia_value(c.value[].lower) == 4
    @test GRDB._julia_value(c.value[].upper) == 6

    c = roundtrip(GRDB._condition(Dict("dimension" => 6, "Picard_rank" => 1)))
    @test c.var"#type" == GRDB.CondType.AND
    @test Set(x.value[].lhs for x in c.value[].cond) == Set(["dimension", "Picard_rank"])
  end

  online = try
    GRDB.list_databases()
    true
  catch
    false
  end

  if online
    @testset "Queries" begin
      @test "smooth_toric" in GRDB.list_databases()
      db = GRDB.get_db("smooth_toric")
      @test "smooth_toric" in GRDB.get_collection_names(db)
      c = db["smooth_toric"]
      d = Dict("dimension" => 6)
      @test length(c, d) == 7622
      rs = GRDB.find(c, d; limit=3, sort_by=["vertices"])
      @test length(rs) == 3
      r = GRDB.find_one(c, Dict("id" => 8635))
      @test r["dimension"] == 6
      P = convex_hull(Oscar.Serialization.JSON3.read(r["vertices"], Vector{Vector{Int}}))
      @test dim(P) == 6
      @test isnothing(GRDB.find_one(c, Dict("dimension" => -1)))
    end
  else
    @info "GRDB server not reachable, skipping online tests"
  end
end
