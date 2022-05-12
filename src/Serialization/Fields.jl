################################################################################
# non-fmpz variant
function save_internal(s::SerializerState, F::Nemo.GaloisField)
    return Dict(
        :characteristic => UInt64(characteristic(F))
    )
end

function load_internal(s::DeserializerState, ::Type{Nemo.GaloisField}, dict::Dict)
    return Nemo.GaloisField(UInt64(dict[:characteristic]))
end

# elements
function save_internal(s::SerializerState, elem::gfp_elem)
    return Dict(
        :parent => save_type_dispatch(s, parent(elem)),
        :data => Nemo.data(elem)
    )
end

function load_internal(s::DeserializerState, z::Type{gfp_elem}, dict::Dict)
    F = load_type_dispatch(s, Nemo.GaloisField, dict[:parent])
    return F(UInt64(dict[:data]))
end


################################################################################
# fmpz variant
function save_internal(s::SerializerState, F::Nemo.GaloisFmpzField)
    return Dict(
        :characteristic => save_type_dispatch(s, characteristic(F))
    )
end

function load_internal(s::DeserializerState, F::Type{Nemo.GaloisFmpzField}, dict::Dict)
    return F(load_type_dispatch(s, fmpz, dict[:characteristic]))
end

# elements
function save_internal(s::SerializerState, elem::gfp_fmpz_elem)
    return Dict(
        :parent => save_type_dispatch(s, parent(elem)),
        :data => save_type_dispatch(s, Nemo.data(elem))
    )
end

function load_internal(s::DeserializerState, ::Type{gfp_fmpz_elem}, dict::Dict)
    F = load_type_dispatch(s, Nemo.GaloisFmpzField, dict[:parent])
    return F(load_type_dispatch(s, fmpz, dict[:data]))
end

################################################################################
# AnticNumberfield
function save_internal(s::SerializerState, K::AnticNumberField)
    return Dict(
        :def_pol => save_type_dispatch(s, defining_polynomial(K))
    )
end

function load_internal(s::DeserializerState, ::Type{AnticNumberField}, dict::Dict)
    def_pol = load_type_dispatch(s, dict[:def_pol], check_namespace=false)
    K, _ = NumberField(def_pol)
    return K
end

#elements
function save_internal(s::SerializerState, k::nf_elem)
    K = parent(k)
    polynomial = parent(defining_polynomial(K))(k)
    K_dict = save_type_dispatch(s, K)
    
    return Dict(
        :parent => K_dict,
        :polynomial => save_type_dispatch(s, polynomial)
    )
end

function load_internal(s::DeserializerState, ::Type{nf_elem}, dict::Dict)
    K = load_type_dispatch(s, dict[:parent], check_namespace=false)
    polynomial = load_type_dispatch(s, dict[:polynomial], check_namespace=false)
    return K(polynomial)
end

################################################################################
# NfAbsNS
function save_internal(s::SerializerState, K::NfAbsNS)
    return Dict(
        :def_pols => save_type_dispatch(s, defining_polynomials(K))
    )
end

function load_internal(s::DeserializerState, ::Type{NfAbsNS}, dict::Dict)
    def_pols = load_type_dispatch(s, dict[:def_pols], check_namespace=false)
    K, _ = NumberField(def_pols)
    return K
end

#elements
function save_internal(s::SerializerState, k::NfAbsNSElem)
    K = parent(k)
    polynomial = Oscar.Hecke.data(k)
    K_dict = save_type_dispatch(s, K)

    return Dict(
        :parent => K_dict,
        :polynomial => save_type_dispatch(s, polynomial)
    )
end

function load_internal(s::DeserializerState, ::Type{NfAbsNSElem}, dict::Dict)
    K = load_type_dispatch(s, dict[:parent], check_namespace=false)
    polynomial = load_type_dispatch(s, dict[:polynomial], check_namespace=false)

    return K(polynomial)
end
