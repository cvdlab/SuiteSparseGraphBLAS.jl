mutable struct GrB_UnaryOp
    p::Ptr{Cvoid}
    ztype::GType
    xtype::GType

    GrB_UnaryOp(unaryop_name, ztype, xtype) = new(load_global(unaryop_name), ztype, xtype)
    GrB_UnaryOp() = new()
end

mutable struct GrB_BinaryOp
    p::Ptr{Cvoid}
    ztype::GType
    xtype::GType
    ytype::GType

    GrB_BinaryOp() = new(C_NULL, NULL, NULL, NULL)
    GrB_BinaryOp(binaryop_name, ztype, xtype, ytype) = new(load_global(binaryop_name), ztype, xtype, ytype)
end

mutable struct GrB_Monoid
    p::Ptr{Cvoid}
    domain::GType

    GrB_Monoid() = new(C_NULL, NULL)
    GrB_Monoid(monoid_name, domain) = new(load_global(monoid_name), domain)
end

mutable struct GrB_Semiring
    p::Ptr{Cvoid}
    xtype::GType
    ytype::GType
    ztype::GType

    GrB_Semiring() = new(C_NULL, NULL, NULL, NULL)
    GrB_Semiring(semiring_name, xtype, ytype, ztype) = new(load_global(semiring_name), xtype, ytype, ztype)
end

# represent a unary operation without assigned type
mutable struct UnaryOperator
    fun::Union{Function, Nothing}
    impl::Vector{GrB_UnaryOp}

    UnaryOperator() = new(nothing, [])
    UnaryOperator(fun) = new(fun, [])
end

mutable struct BinaryOperator
    fun::Union{Function, Nothing}
    impl::Vector{GrB_BinaryOp}

    BinaryOperator() = new(nothing, [])
    BinaryOperator(fun) = new(fun, [])
end

mutable struct Monoid
    impl::Vector{GrB_Monoid}

    Monoid() = new([])
end

mutable struct Semiring
    monoid::Union{Monoid, Nothing}
    binaryop::Union{BinaryOperator, Nothing}
    impl::Vector{GrB_Semiring}

    Semiring() = new(nothing, nothing,[])
    Semiring(monoid, binaryop) = new(monoid, binaryop, [])
end

const Unaryop = Dict{Symbol,UnaryOperator}()
const Binaryop = Dict{Symbol,BinaryOperator}()
const Monoids = Dict{Symbol,Monoid}()
const Semirings = Dict{Symbol,Semiring}()

function Base.getproperty(d::Dict{Symbol,T}, s::Symbol) where T <: Union{UnaryOperator,BinaryOperator,Monoid,Semiring}
    try
        return getfield(d, s)
    catch
        return d[s]
    end
end

_gb_pointer(op::GrB_UnaryOp) = op.p
_gb_pointer(op::GrB_BinaryOp) = op.p
_gb_pointer(op::Monoid) = op.p
_gb_pointer(op::Semiring) = op.p

# import Base:
#         show, ==, pointer, convert, isless, Vector, getindex

# export ZeroBasedIndex, OneBasedIndex, ZeroBasedIndices, OneBasedIndices,
#        GrB_Type, GrB_UnaryOp, GrB_BinaryOp, GrB_Monoid, GrB_Semiring,
#        GrB_Vector, GrB_Matrix, GrB_Descriptor

# const valid_types = Union{Bool, Int8, UInt8, Int16, UInt16, Int32, 
#                           UInt32, Int64, UInt64, Float32, Float64}

# struct ZeroBasedIndex <: Abstract_GrB_Index
#     x::UInt64
# end

# getindex(a::ZeroBasedIndex) = a.x
# show(io::IO, ::MIME"text/plain", a::ZeroBasedIndex) = print(io, "ZeroBasedIndex(", a.x, ")")
# show(io::IO, a::ZeroBasedIndex) = print(io, a.x)
# convert(T::Type{ZeroBasedIndex}, x::Union{Int64, UInt64}) = T(x)
# isless(a::ZeroBasedIndex, b::ZeroBasedIndex) = a.x < b.x
# const ZeroBasedIndices = Vector{ZeroBasedIndex}
# Vector(arr::ZeroBasedIndices) = map(i -> i.x, arr)
# ZeroBasedIndices(arr::Vector{T}) where T <: Integer = ZeroBasedIndex.(arr)

# struct OneBasedIndex <: Abstract_GrB_Index
#     x::UInt64
# end

# getindex(a::OneBasedIndex) = a.x
# show(io::IO, ::MIME"text/plain", a::OneBasedIndex) = print(io, "OneBasedIndex(", a.x, ")")
# show(io::IO, a::OneBasedIndex) = print(io, a.x)
# convert(T::Type{OneBasedIndex}, x::Union{Int64, UInt64}) = T(x)
# isless(a::OneBasedIndex, b::OneBasedIndex) = a.x < b.x
# const OneBasedIndices = Vector{OneBasedIndex}
# Vector(arr::OneBasedIndices) = map(i -> i.x, arr)
# OneBasedIndices(arr::Vector{T}) where T <: Integer = OneBasedIndex.(arr)

# ZeroBasedIndex(a::OneBasedIndex) = ZeroBasedIndex(a.x-1)
# OneBasedIndex(a::ZeroBasedIndex) = OneBasedIndex(a.x+1)

# Vector{ZeroBasedIndex}(arr::OneBasedIndices) = ZeroBasedIndex.(arr)
# Vector{OneBasedIndex}(arr::ZeroBasedIndices) = OneBasedIndex.(arr)

# mutable struct GrB_Type{T <: valid_types} <: Abstract_GrB_Type
#     p::Ptr{Cvoid}
# end
# GrB_Type{T}() where T = GrB_Type{T}(C_NULL)
# show(io::IO, ::GrB_Type{T}) where T = print("GrB_Type{" * string(T) * "}")

# mutable struct GrB_UnaryOp <: Abstract_GrB_UnaryOp
#     p::Ptr{Cvoid}
# end
# GrB_UnaryOp() = GrB_UnaryOp(C_NULL)
# show(io::IO, ::GrB_UnaryOp) = print("GrB_UnaryOp")

# mutable struct GrB_BinaryOp <: Abstract_GrB_BinaryOp
#     p::Ptr{Cvoid}
# end
# GrB_BinaryOp() = GrB_BinaryOp(C_NULL)
# show(io::IO, ::GrB_BinaryOp) = print("GrB_BinaryOp")

# mutable struct GrB_Monoid <: Abstract_GrB_Monoid
#     p::Ptr{Cvoid}
# end
# GrB_Monoid() = GrB_Monoid(C_NULL)
# show(io::IO, ::GrB_Monoid) = print("GrB_Monoid")

# mutable struct GrB_Semiring <: Abstract_GrB_Semiring
#     p::Ptr{Cvoid}
# end
# GrB_Semiring() = GrB_Semiring(C_NULL)
# show(io::IO, ::GrB_Semiring) = print("GrB_Semiring")

# mutable struct GrB_Vector{T <: valid_types} <: Abstract_GrB_Vector
#     p::Ptr{Cvoid}
# end
# GrB_Vector{T}() where T = GrB_Vector{T}(C_NULL)
# show(io::IO, ::GrB_Vector{T}) where T = print("GrB_Vector{" * string(T) * "}")

# mutable struct GrB_Matrix{T <: valid_types} <: Abstract_GrB_Matrix
#     p::Ptr{Cvoid}
# end
# GrB_Matrix{T}() where T = GrB_Matrix{T}(C_NULL)
# show(io::IO, ::GrB_Matrix{T}) where T = print("GrB_Matrix{" * string(T) * "}")

# mutable struct GrB_Descriptor <: Abstract_GrB_Descriptor
#     p::Ptr{Cvoid}
# end
# GrB_Descriptor() = GrB_Descriptor(C_NULL)
# show(io::IO, ::GrB_Descriptor) = print("GrB_Descriptor")

# mutable struct GxB_SelectOp
#     p::Ptr{Cvoid}
# end
# GxB_SelectOp() = GxB_SelectOp(C_NULL)
# show(io::IO, ::GxB_SelectOp) = print("GxB_SelectOp")

# struct GrB_NULL_Type <: Abstract_GrB_NULL
#     p::Ptr{Cvoid}
# end
# show(io::IO, ::GrB_NULL_Type) = print("GrB_NULL")

# mutable struct GrB_ALL_Type <: Abstract_GrB_ALL
#     p::Ptr{Cvoid}
# end
# pointer(x::GrB_ALL_Type) = x.p
# show(io::IO, ::GrB_ALL_Type) = print("GrB_ALL")
# ZeroBasedIndices(::GrB_ALL_Type) = GrB_ALL