function cgs_iter(I::MPolyIdeal{<:MPolyRingElem{<:MPolyRingElem}}) #, ord::MonomialOrdering)
  R = base_ring(I)
  coeff_R = coefficient_ring(R)
  phi = Oscar.flatten(R)
  flat_R = codomain(phi)
  Ro = monomial_ordering(gens(flat_R)[1:ngens(R)], :degrevlex)
  So = monomial_ordering(gens(flat_R)[ngens(R) + 1:end], :degrevlex)
  o = Ro * So
  J0 = phi(I)
  vanishing_todo = [ideal(zero(codomain(phi)))]
  cgs = Tuple{MPolyIdeal, MPolyIdeal, Vector{MPolyRingElem}}[]
  while !isempty(vanishing_todo)
    a = pop!(vanishing_todo)
    @show J = J0 + a
    G = groebner_basis(J; algorithm=:f4)
    b = eliminate(ideal(G), 1:ngens(R))
    if !all(g -> radical_membership(g, b), gens(a))
      push!(cgs, (a, b, [R(1)]))
      !any(j -> contains(b, j), vanishing_todo) && push!(vanishing_todo, b)
    else
      min_basis = Dict{NTuple{ngens(R), Int}, Vector{MPolyRingElem}}[]
      G_MB = MPolyRingElem[]
      for x in G
        if !ideal_membership(x, b)
          LE = leading_exponent(x; ordering=o)
          v = get(min_basis, NTuple{ngens(R), Int}(LE[1:ngens(R)]), MPolyRingElem[])
          push!(v, coeff_R([1], [LE[ngens(R) + 1:end]]))
          push!(G_MB, x)
        end
      end
      all_c_t = MPolyIdeal[]
      new_vanishing = MPolyIdeal[]
      for (t, c_t) in min_basis
        c_t_ideal = ideal(flat_R, c_t)
        push!(all_c_t, c_t_ideal)
        !contains(b, c_t_ideal) && push!(new_vanishing, _minimalized(c_t_ideal + b))
      end
      push!(cgs, (b, reduce(*, all_c_t; init=ideal(flat_R(1))), G_MB))

      for potential_todo in new_vanishing
        !any(j -> contains(potential_todo, j), vanishing_todo) && push!(vanishing_todo, potential_todo)
      end
    end
  end
  return cgs
end

function _minimalized(I::MPolyIdeal)
  return ideal([reduce(*, first.(collect(factor(g))); init=base_ring(I)(1)) for g in gens(I)])
end

@doc raw"""
     comprehensive_groebner_system(I::MPolyIdeal [, o::MonomialOrdering])

"""
function comprehensive_groebner_system(I::MPolyIdeal, o::MonomialOrdering)
  cgs = Singular.LibGrobcov.cgsdr(Oscar.singular_generators(I, o))
  R = base_ring(I)
  return [
    # each entry describes describes a reduce groebner basis where the coefficients
    # live on the variety V(full) \ V(hole), the entries are ordered as
    # [ full, hole, gb ]
    [ideal(R, SI) for SI in full_hole_basis] for full_hole_basis in cgs
  ]
end

comprehensive_groebner_system(I::MPolyIdeal) = comprehensive_groebner_system(I, degrevlex(base_ring(I)))
