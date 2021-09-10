export ProjCurve, defining_ideal, curve_components, reduction, isirreducible,
       jacobi_ideal

################################################################################
abstract type ProjectiveCurve end
################################################################################
@doc Markdown.doc"""
    ProjCurve(I::MPolyIdeal)

Return the Projective Curve defined by the ideal `I`, where `I` defines a
projective variety of dimension `1`.

# Example
```jldoctest
julia> S, (x, y, z, t) = PolynomialRing(QQ, ["x", "y", "z", "t"])
T(Multivariate Polynomial Ring in x, y, z, t over Rational Field, fmpq_mpoly[^[[Ax, y, z, t])

julia> T, _ = grade(S)
(Multivariate Polynomial Ring in x, y, z, t over Rational Field graded by
  x -> [1]
  y -> [1]
  z -> [1]
  t -> [1], MPolyElem_dec{fmpq,fmpq_mpoly}[x, y, z, t])

julia> I = ideal(T, [x^2, y^2*z, z^2])
ideal(x^2, y^2*z, z^2)

julia> C = Oscar.ProjCurve(I)
Projective curve defined by the ideal(x^2, y^2*z, z^2)
```
"""
mutable struct ProjCurve <: ProjectiveCurve
    I::MPolyIdeal
    ambiant_dim::Int
    components::Dict{ProjCurve, ProjCurve}
    function ProjCurve(I::MPolyIdeal)
        dim(I) == 2 || error("wrong dimension for a projective curve")
        n = nvars(base_ring(I)) - 1
        new(I, n, Dict{ProjCurve, ProjCurve}())
    end

    function Base.show(io::IO, C::ProjCurve)
        if !get(io, :compact, false)
            println(io, "Projective curve defined by the ", C.I)
        else
            println(io, C.I)
        end
    end
end

################################################################################

@doc Markdown.doc"""
    defining_ideal(C::ProjCurve)

Return the defining ideal of the projective curve `C`.
"""
function Oscar.defining_ideal(C::ProjCurve)
    return C.I
end

################################################################################

function Base.hash(C::ProjCurve, h::UInt)
  I = Oscar.defining_ideal(C)
  return hash(I, h)
end
################################################################################
@doc Markdown.doc"""
    in(P::Oscar.Geometry.ProjSpcElem, C::ProjCurve)

Return `true` if the point `P` is on the curve `C`, and `false` otherwise.

# Example
```jldoctest
julia> S, (x, y, z, t) = PolynomialRing(QQ, ["x", "y", "z", "t"])
(Multivariate Polynomial Ring in x, y, z, t over Rational Field, fmpq_mpoly[x, y, z, t])

julia> T, _ = grade(S)
(Multivariate Polynomial Ring in x, y, z, t over Rational Field graded by
  x -> [1]
  y -> [1]
  z -> [1]
  t -> [1], MPolyElem_dec{fmpq,fmpq_mpoly}[x, y, z, t])

julia> I = ideal(T, [x^2, y^2*z, z^2])
ideal(x^2, y^2*z, z^2)

julia> C = Oscar.ProjCurve(I)
Projective curve defined by the ideal(x^2, y^2*z, z^2)


julia> PP = projective_space(QQ, 3)
(Projective space of dim 3 over Rational Field
, MPolyElem_dec{fmpq,fmpq_mpoly}[x[0], x[1], x[2], x[3]])

julia> P = Oscar.Geometry.ProjSpcElem(PP[1], [QQ(0), QQ(2), QQ(0), QQ(5)])
(0 : 2 : 0 : 5)

julia> P in C
true
```
"""
function Base.in(P::Oscar.Geometry.ProjSpcElem, C::ProjCurve)
    I = Oscar.defining_ideal(C)
    V = I.gens.O
    s = length(V)
    i = 1
    while i <= s
        if !iszero(evaluate(V[i], P.v))
            return false
        end
        i = i + 1
    end
    return true
end

################################################################################
@doc Markdown.doc"""
    curve_components(C::ProjCurve)

Return a dictionary containing the irreducible components of `C` and the
corresponding reduced curve.

# Example
```jldoctest
julia> S, (x, y, z, t) = PolynomialRing(QQ, ["x", "y", "z", "t"])
(Multivariate Polynomial Ring in x, y, z, t over Rational Field, fmpq_mpoly[x, y, z, t])

julia> T, _ = grade(S)
(Multivariate Polynomial Ring in x, y, z, t over Rational Field graded by
  x -> [1]
  y -> [1]
  z -> [1]
  t -> [1], MPolyElem_dec{fmpq,fmpq_mpoly}[x, y, z, t])

julia> I = ideal(T, [x^2*z^2 - y*z^2*t, x^2*y*z - y^2*z*t, x^3*z + z^2*t^2, x^3*y + x^2*z*t, x^4 - x^2*y*t, x*z^2*t^2 + y^2*z*t^2, x*y*z^2*t + z^3*t^2, x*y^2*z*t + y*z^2*t^2, x^2*y^2*t - z^2*t^3])
ideal(x^2*z^2 - y*z^2*t, x^2*y*z - y^2*z*t, x^3*z + z^2*t^2, x^3*y + x^2*z*t, x^4 - x^2*y*t, x*z^2*t^2 + y^2*z*t^2, x*y*z^2*t + z^3*t^2, x*y^2*z*t + y*z^2*t^2, x^2*y^2*t - z^2*t^3)

julia> C = Oscar.ProjCurve(I)
Projective curve defined by the ideal(x^2*z^2 - y*z^2*t, x^2*y*z - y^2*z*t, x^3*z + z^2*t^2, x^3*y + x^2*z*t, x^4 - x^2*y*t, x*z^2*t^2 + y^2*z*t^2, x*y*z^2*t + z^3*t^2, x*y^2*z*t + y*z^2*t^2, x^2*y^2*t - z^2*t^3)


julia> Oscar.curve_components(C)
Dict{Oscar.PlaneCurveModule.ProjCurve,Oscar.PlaneCurveModule.ProjCurve} with 3 entries:
  ideal(y^3 - z^2*t, x*z + y^2, x*y + z*t, x^2 - y*t)… => ideal(y^3 - z^2*t, x*z + y^2, x*y + z*t, x^2 - y*t)…
  ideal(z, x^2)…                                       => ideal(z, x)…
  ideal(t^2, x*t, x^2 - y*t)…                          => ideal(t, x)…
```
"""
function curve_components(C::ProjCurve)
    if isempty(C.components)
        I = Oscar.defining_ideal(C)
        L = primary_decomposition(I)
        s = length(L)
        D = Dict{ProjCurve, ProjCurve}()
        for i in 1:s
            if dim(L[i][1]) == 2
                D[ProjCurve(L[i][1])] = ProjCurve(L[i][2])
            end
        end
        C.components = D
    end
    return C.components
end

################################################################################

@doc Markdown.doc"""
    isirreducible(C::ProjCurve)

Return `true` if `C` is irreducible, and `false` otherwise.

# Example
```jldoctest
julia> S, (x, y, z, t) = PolynomialRing(QQ, ["x", "y", "z", "t"])
T(Multivariate Polynomial Ring in x, y, z, t over Rational Field, fmpq_mpoly[^[[Ax, y, z, t])

julia> T, _ = grade(S)
(Multivariate Polynomial Ring in x, y, z, t over Rational Field graded by
  x -> [1]
  y -> [1]
  z -> [1]
  t -> [1], MPolyElem_dec{fmpq,fmpq_mpoly}[x, y, z, t])

julia> I = ideal(T, [x^2, y^2*z, z^2])
ideal(x^2, y^2*z, z^2)

julia> C = Oscar.ProjCurve(I)
Projective curve defined by the ideal(x^2, y^2*z, z^2)

julia> Oscar.isirreducible(C)
true
```
"""
function Oscar.isirreducible(C::ProjCurve)
    L = curve_components(C)
    return length(L) == 1
end

################################################################################

@doc Markdown.doc"""
    reduction(C::ProjCurve)

Return the projective curve defined by the radical of the defining ideal of `C`.

# Example
```jldoctest
julia> S, (x, y, z, t) = PolynomialRing(QQ, ["x", "y", "z", "t"])
T(Multivariate Polynomial Ring in x, y, z, t over Rational Field, fmpq_mpoly[^[[Ax, y, z, t])

julia> T, _ = grade(S)
(Multivariate Polynomial Ring in x, y, z, t over Rational Field graded by
  x -> [1]
  y -> [1]
  z -> [1]
  t -> [1], MPolyElem_dec{fmpq,fmpq_mpoly}[x, y, z, t])

julia> I = ideal(T, [x^2, y^2*z, z^2])
ideal(x^2, y^2*z, z^2)

julia> C = Oscar.ProjCurve(I)
Projective curve defined by the ideal(x^2, y^2*z, z^2)

julia> Oscar.reduction(C)
Projective curve defined by the ideal(z, x)
```
"""
function reduction(C::ProjCurve)
    J = radical(Oscar.defining_ideal(C))
    return ProjCurve(J)
end

################################################################################

@doc Markdown.doc"""
    jacobi_ideal(C::ProjCurve)

Return the jacobian ideal of the defining ideal of `C`.

# Example
```jldoctest
julia> S, (x, y, z, t) = PolynomialRing(QQ, ["x", "y", "z", "t"])
T(Multivariate Polynomial Ring in x, y, z, t over Rational Field, fmpq_mpoly[^[[Ax, y, z, t])

julia> T, _ = grade(S)
(Multivariate Polynomial Ring in x, y, z, t over Rational Field graded by
  x -> [1]
  y -> [1]
  z -> [1]
  t -> [1], MPolyElem_dec{fmpq,fmpq_mpoly}[x, y, z, t])

julia> I = ideal(T, [x^2, y^2*z, z^2])
ideal(x^2, y^2*z, z^2)

julia> C = Oscar.ProjCurve(I)
Projective curve defined by the ideal(x^2, y^2*z, z^2)

julia> Oscar.jacobi_ideal(C)
ideal(4*x*y*z, 2*x*y^2, 4*x*z, 4*y*z^2)
```
"""
function Oscar.jacobi_ideal(C::ProjCurve)
    I = Oscar.defining_ideal(C)
    R = base_ring(I)
    k = C.ambiant_dim - 1
    M = jacobi_matrix(I.gens.O)
    V = minors(M, k)
    filter!(!iszero, V)
    return ideal(R, V)
end

################################################################################

@doc Markdown.doc"""
    invert_birational_map(phi::Vector{T}, C::ProjCurve) where {T <: MPolyElem}

Return a dictionary where `image` represents the image of the birational map
given by `phi`, and `inverse` represents its inverse, where `phi` is a
birational map of the projective curve `C` to its image in the projective
space of dimension `size(phi) - 1`.
Note that the entries of `inverse` should be considered as
representatives of elements in `R/image`, where `R` is the basering.
"""
function invert_birational_map(phi::Vector{T}, C::ProjCurve) where {T <: MPolyElem}
    s = parent(phi[1])
    I = ideal(s, phi)
    singular_assure(I)
    IC = defining_ideal(C)
    singular_assure(IC)
    L = Singular.LibParaplanecurves.invertBirMap(I.gens.S, IC.gens.S)
    R = _fromsingular_ring(L[1])
    J = L[2][:J]
    psi = L[2][:psi]
    return Dict([("image", gens(ideal(R, J))), ("inverse", gens(ideal(R, psi)))])
end
