/// FunctionMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The structure of function type metadata.
struct FunctionTypeMetadataLayout: MetadataLayout {
  struct FunctionTypeFlags: OptionSet {
    var rawValue: Int

    static let numParametersMask = FunctionTypeFlags(rawValue: 0x0000FFFF)
    static let conventionMask    = FunctionTypeFlags(rawValue: 0x00FF0000)
    static let conventionShift   = FunctionTypeFlags(rawValue: 16)
    static let throwsMask        = FunctionTypeFlags(rawValue: 0x01000000)
    static let paramFlagsMask    = FunctionTypeFlags(rawValue: 0x02000000)
    static let escapingMask      = FunctionTypeFlags(rawValue: 0x04000000)
  }
  var layout: some DerivedMetadataLayout { 
    Metadata {
      SwiftMetadataLayout()
      Flags<FunctionTypeFlags>()
      /// The type metadata for the result type.
      DirectPointer<SwiftMetadataLayout>()
    }
  }
}
