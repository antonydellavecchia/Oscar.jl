#=
Alternative:

module SmallGroups

all_groups / all
one
all_group_ids

groups_available(order) / availble
ids_available(order)

group(n, i)
identify(group)

end


- add deprecations for the old names
- hook up the docstrings into the manual
- improve docstrings, e.g. by borrowing from their GAP counterparts
- add examples

=#

export
    all_small_groups,
    all_small_group_ids, # IdsOfAllSmallGroups
    number_small_groups,
    has_number_small_groups,
    has_small_group_ids,
    has_small_groups,
    small_group,
    small_group_identification



###################################################################
# Small groups
###################################################################

"""
    has_number_small_groups(n::IntegerUnion)

Return `true` if the number of groups of order `n` is known, otherwise `false`.

# Examples
```jldoctest
julia> has_number_small_groups(1024)
true

julia> has_number_small_groups(2048)
false
```
"""
function has_number_small_groups(n::IntegerUnion)
    n >= 1 || throw(ArgumentError("group order must be positive, not $n"))
    return GAP.Globals.NumberSmallGroupsAvailable(GAP.Obj(n))
end

"""
    has_small_groups(n::IntegerUnion)

Return `true` if the groups of order `n` are available via `small_group`
and `all_small_groups`, otherwise `false`.

# Examples
```jldoctest
julia> has_small_groups(512)
true

julia> has_small_groups(1024)
false
```
"""
function has_small_groups(n::IntegerUnion)
    n >= 1 || throw(ArgumentError("group order must be positive, not $n"))
    return GAP.Globals.SmallGroupsAvailable(GAP.Obj(n))
end

"""
    has_small_group_ids(n::IntegerUnion)

Return `true` if identification for groups of order `n` is available via
`small_group_identification`, otherwise `false`.

# Examples
```jldoctest
julia> has_small_group_ids(256)
true

julia> has_small_group_ids(512)
false
```
"""
function has_small_group_ids(n::IntegerUnion)
    n >= 1 || throw(ArgumentError("group order must be positive, not $n"))
    return GAP.Globals.IdGroupsAvailable(GAP.Obj(n))
end

"""
    small_group(::Type{T}, n::IntegerUnion, i::IntegerUnion) where T
    small_group(n::IntegerUnion, i::IntegerUnion)

Return the `i`-th group of order `n` in the Small Groups Library. If a type
`T` is specified then an attempt is made to return the result with that type.
If `T` is omitted then the resulting group will have type `PcGroup` if it is
solvable, otherwise it will be of type `PermGroup`.

# Examples
```jldoctest
julia> small_group(60, 4)
<pc group of size 60 with 4 generators>

julia> small_group(60, 5)
Group([ (1,2,3,4,5), (1,2,3) ])

julia> small_group(PcGroup, 60, 4)
<pc group of size 60 with 2 generators>
```
"""
function small_group(::Type{T}, n::IntegerUnion, m::IntegerUnion) where T
  G = _small_group(n, m)
  return T(G)
end

function small_group(n::IntegerUnion, m::IntegerUnion)
  G = _small_group(n, m)
  T = _get_type(G)
  return T(G)
end

function _small_group(n::IntegerUnion, m::IntegerUnion)
  N = number_small_groups(n)
  m <= N || throw(ArgumentError("There are only $N groups of order $n, up to isomorphism."))
  return GAP.Globals.SmallGroup(GAP.Obj(n), GAP.Obj(m))
end


"""
    small_group_identification(G::Group)

Return `(n, m)`, where `G` is isomorphic with `small_group(n, m)`.

# Examples
```jldoctest
julia> small_group_identification(alternating_group(5))
(60, 5)
```
"""
function small_group_identification(G::GAPGroup)
   isfinite(G) || error("group is not finite")
   res = GAP.Globals.IdGroup(G.X)
   res !== GAP.Globals.fail || error("identification is not available for groups of order $(order(G))")
   return Tuple{Int,Int}(res)
end


"""
    number_small_groups(n::IntegerUnion)

Return the number of groups of order `n`, up to isomorphism.
"""
function number_small_groups(n::IntegerUnion)
    n >= 1 || throw(ArgumentError("group order must be positive, not $n"))
    return fmpz(GAP.Globals.NumberSmallGroups(n))
end


"""
    all_small_groups(L...)

TODO: adjust this text

Return the list of all groups (up to isomorphism) of order `n` and satisfying
the conditions in `L`. Here, `L` is a vector whose arguments are organized as
`L` = [ `func1`, `arg1`, `func2`, `arg2`, ... ], and the function returns all
the groups `G` satisfying the conditions `func1`(`G`) = `arg1`, `func2`(`G`) =
`arg2`, etc. An argument can be omitted if it corresponds to the boolean value
`true`.

The following command returns the list of all abelian non-cyclic groups
of order 12.

# Examples
```jldoctest
julia> all_small_groups(12, iscyclic, false, isabelian)
1-element Vector{PcGroup}:
 <pc group of size 12 with 3 generators>

```

The type of the groups is `PcGroup` if the group is solvable, `PermGroup` otherwise.
"""
function all_small_groups(L...)
   !isempty(L) || throw(ArgumentError("must specify at least one filter"))
   if L[1] isa Int
      L = (order => L[1], L[2:end]...)
   end
   gapargs = translate_group_library_args(L)
   K = GAP.Globals.AllSmallGroups(gapargs...)
   return [_get_type(x)(x) for x in K]
end
#T what does this comment mean?

#T problem:

#T all_small_groups( 60, issimple ) -> Array{PermGroup,1}
#T all_small_groups( 60 )  -> Array{Oscar.GAPGroup,1}
#T all_small_groups( 59 )  -> Array{PcGroup,1}

#T Do we want this???
