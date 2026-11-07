# Regenerates ../src/gen from the .proto files in this directory.
# Run from an environment with ProtoBuf and gRPCClient:
#   julia --project=<env> experimental/GRDB/proto/generate.jl
using ProtoBuf, gRPCClient
grpc_register_service_codegen(legacy = false)
gen = joinpath(@__DIR__, "..", "src", "gen")
rm(gen; recursive = true, force = true)
protojl(["kvdb.proto", "condition.proto", "value.proto", "sort.proto"], @__DIR__, gen)
