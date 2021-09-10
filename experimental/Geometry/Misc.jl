import AbstractAlgebra.Ring
import AbstractAlgebra.RingElement
import Oscar: radical_membership


module Misc
using Oscar

export add_variables, divides_power

####################################################################
#  
#  Miscellaneous routines used in the above 
#
####################################################################


function add_variables( R::T, new_vars::Vector{String} ) where{ T<:MPolyRing } 
  k = base_ring(R)
  old_vars = String.( symbols(R) )
  n = length( old_vars )
  vars = vcat( old_vars, new_vars )
  S, v = PolynomialRing( k, vars )
  phi = AlgebraHomomorphism( R, S, gens(S)[1:n] )
  y = v[n+1:length(v)]
  return S, phi, y
end

function add_variables( P::T, new_vars::Vector{String} ) where{ T<:MPolyQuo } 
  R = base_ring(P)
  k = base_ring(R)
  S, phi, y = add_variables( R, new_vars )
  I = ideal( S, [ phi(g) for g in gens(modulus(P)) ] )
  Q, projection = quo( S, I )
  phi_quot = AlgebraHomomorphism( P, Q, [projection(g) for g in phi.image] )
  return Q, phi_quot, [ projection(g) for g in y]
end

####################################################################
#
# Test whether some power of the polynomial f is contained in the 
# principal ideal generated by g
#
function Oscar.radical_membership( f::U, g::U ) where{ U<:MPolyElem }
  R = parent(f)
  if R != parent(g) 
    error( "Polynomials do not belong to the same ring" )
  end
  S, phi, t = add_variables( R, ["t"] )
  I = ideal(S, [phi(g), one(S)-t[1]*phi(f)])
  G = groebner_basis(I,complete_reduction=true)
  if length(G)==1 && G[1] == one(S)
    return true
  end
  return false
end

function Oscar.radical_membership( f::U, g::U ) where{ U<:MPolyQuoElem }
  P = parent(f)
  R = base_ring(P)
  if P != parent(g) 
    error( "Polynomials do not belong to the same ring" )
  end
  S, phi, t = add_variables( R, ["t"] )
  I = ideal(S, 
	    vcat( [phi(lift(g)), one(S)-t[1]*phi(lift(f))],
		 [phi(h) for h in gens(modulus(P))] )
	    )
  G = groebner_basis(I,complete_reduction=true)
  if length(G)==1 && G[1] == one(S)
    return true
  end
  return false
end

##################################################################
#
# Checks whether some power of u is contained in the principal ideal 
# generated by g and returns a solution (k,a) of the equation 
#    u^k = a*g
# If no such solution exists, it returns (-1,0).
function divides_power( g::T, u::T, check_radical_membership::Bool=false ) where{ T<:MPolyElem }
  println( "Check whether some power of $u is divisible by $g" )
  R = parent(g)
  parent(g) == parent(u) || error( "elements are not contained in the same ring" )
  # Test for radical membership in the first place.
  # TODO: Doesn't this computation already allow us to read 
  # off our desired coefficients? How expensive is this compared 
  # to what follows?
  if check_radical_membership && (!radical_membership( u, g ))
    return (-1, zero(R))
  end

  # Check successivly higher powers of u for containment in ⟨g⟩. 
  # Once such a power is found, try to decrease it again to 
  # find the optimum.
  powers = [u]
  check = false
  a = zero(R)
  while true
    # println( "looking at the $(2^(length(powers)-1))-th power..." )
    check, a = divides( last(powers), g )
    if check
      break
    end
    push!( powers, last(powers)^2 )
  end

  # Now a power u^(2^(l-1)) is found that is divided by g with 
  # l being the length of the vector powers. We use logarithmic 
  # bisection in order to find the optimal power u^k for 
  # which this happens for the first time

  k = 2^(length(powers)-1)
  upper = pop!(powers)
  if length(powers) == 0
    # In this case u = a * g with exponent 1. No need for 
    # further bisection.
    return (1, a)
  end
  l = 2^(length(powers)-1)
  lower = pop!(powers)
  b = one(R)
  while length(powers) > 0
    # println( "looking between the $l-th power and the $k-th power..." )
    power = pop!(powers)
    middle = lower*power
    (check, b) = divides( middle, g )
    if check == true
      upper = middle
      a = b
      k -= 2^length(powers)
    else
      lower = middle
      l += 2^length(powers)
    end
  end
  return (k, a)
end

# TODO: Up to now, this is merely a copy of the above routine. 
# At this point, 'divide' seems to have a bug that causes 
# the routine to break sometimes.
function divides_power( g::T, u::T, check_radical_membership::Bool=false ) where{ T<:MPolyQuoElem }
  # println( "Check whether some power of $u is divisible by $g" )
  R = parent(g)
  parent(g) == parent(u) || error( "elements are not contained in the same ring" )

  # Test for radical membership in the first place.
  !check_radical_membership || ( radical_membership( lift(u), modulus(parent(g)) + ideal( parent(lift(g)), lift(g) )) || return (-1, zero(R)))
  # println( "Test for radical membership was positive." )

  # Check successivly higher powers of u for containment in ⟨g⟩. 
  # Once such a power is found, try to decrease it again to 
  # find the optimum.
  powers = [u]
  check = false
  a = zero(R)
  while true
    # println( "looking at the $(2^(length(powers)-1))-th power..." )
    global crash = ( last(powers), g )
    check, a = divides( last(powers), g )
    if check
      break
    end
    push!( powers, last(powers)^2 )
  end

  # Now a power u^(2^(l-1)) is found that is divided by g with 
  # l being the length of the vector powers. We use logarithmic 
  # bisection in order to find the optimal power u^k for 
  # which this happens for the first time

  k = 2^(length(powers)-1)
  upper = pop!(powers)
  if length(powers) == 0
    # In this case u = a * g with exponent 1. No need for 
    # further bisection.
    return (1, a)
  end
  l = 2^(length(powers)-1)
  lower = pop!(powers)
  b = one(R)
  while length(powers) > 0
    # println( "looking between the $l-th power and the $k-th power..." )
    power = pop!(powers)
    middle = lower*power
    (check, b) = divides( middle, g )
    if check == true
      upper = middle
      a = b
      k -= 2^length(powers)
    else
      lower = middle
      l += 2^length(powers)
    end
  end
  return (k, a)
end

end # of module
