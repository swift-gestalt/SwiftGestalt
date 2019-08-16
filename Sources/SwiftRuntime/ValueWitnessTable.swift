/// ValueWitnessTable.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

struct ValueWitnessTableLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      ///   T *(*initializeBufferWithCopyOfBuffer)(B *dest, B *src, M *self)
      FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), OpaquePointer>()
      ///   void (*destroy)(T *object, witness_t *self)
      FunctionPointer<(OpaquePointer, OpaquePointer), Void>()
      ///   T *(*initializeWithCopy)(T *dest, T *src, M *self)
      FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), OpaquePointer>()
      ///   T *(*assignWithCopy)(T *dest, T *src, M *self)
      FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), OpaquePointer>()
      ///   T *(*initializeWithTake)(T *dest, T *src, M *self)
      FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), OpaquePointer>()
      ///   T *(*assignWithTake)(T *dest, T *src, M *self)
      FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), OpaquePointer>()
      /// unsigned (*getEnumTagSinglePayload)(const T* enum, UINT_TYPE emptyCases)
      FunctionPointer<(OpaquePointer, UInt32), UInt32>()
      /// void (*storeEnumTagSinglePayload)(T* enum, UINT_TYPE whichCase, UINT_TYPE emptyCases)
      FunctionPointer<(OpaquePointer, UInt32, UInt32), Void>()
      // Size (bytes)
      Constant<Int>()
      // Stride
      Constant<Int>()
      // Flags
      Flags<ValueWitnessFlags>()
    }
  }
}

struct ValueWitnessFlags: OptionSet {
  var rawValue: Int32

  static let alignmentMask = 0x0000FFFF
  static let isNonPOD = 0x00010000
  static let isNonInline = 0x00020000
  static let hasExtraInhabitants = 0x00040000
  static let hasSpareBits = 0x00080000
  static let isNonBitwiseTakable = 0x00100000
  static let hasEnumWitnesses = 0x00200000
}

//struct InProcess {
//  static constexpr size_t PointerSize = sizeof(uintptr_t)
//  using StoredPointer = uintptr_t
//  using StoredSize = size_t
//  using StoredPointerDifference = ptrdiff_t
//
//  static_assert(sizeof(StoredSize) == sizeof(StoredPointerDifference),
//  "target uses differently-sized size_t and ptrdiff_t")
//
//  template <typename T>
//  using Pointer = T*
//
//  template <typename T, bool Nullable = false>
//  using FarRelativeDirectPointer = FarRelativeDirectPointer<T, Nullable>
//
//  template <typename T, bool Nullable = false>
//  using RelativeIndirectablePointer =
//  RelativeIndirectablePointer<T, Nullable>
//
//  template <typename T, bool Nullable = true>
//  using RelativeDirectPointer = RelativeDirectPointer<T, Nullable>
//}
