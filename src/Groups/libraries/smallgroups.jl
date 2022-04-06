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
    small_groups_available,   # NumberSmallGroupsAvailable
    small_group_ids_available,  # IdGroupsAvailable
    small_group,
    small_group_identification



###################################################################
# Small groups
###################################################################

"""
    small_group(n::Int, i::Int)

Return the `i`-th group of order `n` in the catalogue of GAP's Small Groups
Library. The group is given of type `PcGroup` if the group is solvable,
`PermGroup` otherwise.
"""
function small_group(n::Int, m::Int)
  N = number_small_groups(n)
  @assert m <= N "There are only $N groups of order $n, up to isomorphism."
  G = GAP.Globals.SmallGroup(n, m)
  T = _get_type(G)
  return T(G)
end

"""
    small_group_identification(G::Group)

Return `(n, m)`, where `G` is isomorphic with `small_group(n, m)`.
"""
function small_group_identification(G::GAPGroup)
  r = GAP.Globals.IdGroup(G.X)
  return (r[1], r[2])
end

"""
    number_small_groups(n::IntegerUnion)

Return the number of groups of order `n`, up to isomorphism.
"""
function number_small_groups(n::IntegerUnion)
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
