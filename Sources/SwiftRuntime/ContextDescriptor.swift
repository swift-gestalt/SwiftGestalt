/// ContextDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

struct ContextDescriptorFlags: OptionSet {
  var rawValue: Int32
}

struct ContextDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Flags describing the context, including its kind and format version.
      Flags<ContextDescriptorFlags>()

      /// The parent context, or null if this is a top-level context.
      RelativeIndirectablePointerLayout<ContextDescriptorLayout>()
    }
  }
}

struct ModuleContextDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      ContextDescriptorLayout()
      /// The module name.
      RelativeDirectPointerLayout<CString>()
    }
  }
}

struct GenericContextDescriptorHeaderLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// NumParams
      Constant<Int16>()
      /// NumRequirements
      Constant<Int16>()
      /// NumKeyArguments
      Constant<Int16>()
      /// NumExtraArguments
      Constant<Int16>()
    }
  }
}


struct GenericEnvironmentFlags: OptionSet {
  var rawValue: UInt32
}

struct GenericParamDescriptor: OptionSet {
  var rawValue: UInt8
}

struct GenericEnvironmentLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }

  var layout: some MetadataLayout {
    Metadata {
      Flags<GenericEnvironmentFlags>()
    }
    .withTrailingObjects {
      GenericEnvironmentLayout()
      Constant<UInt16>()
      Flags<GenericParamDescriptor>()
      GenericRequirementDescriptorLayout()
    }
  }
}

struct RelativeProtocolDescriptorPointerLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The relative pointer itself.
      ///
      /// The `AnyProtocol` value type ensures that we can reference any
      /// protocol descriptor it will be reinterpret_cast to the appropriate
      /// protocol descriptor type.
      ///
      /// The `bool` integer value will be false to indicate that the protocol
      /// is a Swift protocol, or true to indicate that this references
      /// an Objective-C protocol.
      RelativeIndirectablePointerIntPairLayout<ProtocolDescriptorLayout, Bool>()
    }
  }
}

enum GenericRequirementKind : UInt8 {
  /// A protocol requirement.
  case `protocol` = 0
  /// A same-type requirement.
  case sameType = 1
  /// A base class requirement.
  case baseClass = 2
  /// A "same-conformance" requirement, implied by a same-type or base-class
  /// constraint that binds a parameter with protocol requirements.
  case sameConformance = 3
  /// A layout constraint.
  case layout = 0x1F
}

struct GenericRequirementFlags: OptionSet {
  var rawValue: UInt32
}

enum GenericRequirementLayoutKind : UInt32 {
  // A class constraint.
  case `class` = 0
}

struct GenericRequirementDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      Flags<GenericRequirementFlags>()

      /// The type that's constrained, described as a mangled name.
      RelativeDirectPointerLayout<CString>()

      Union {
        /// A mangled representation of the same-type or base class the param is
        /// constrained to.
        ///
        /// Only valid if the requirement has SameType or BaseClass kind.
        RelativeDirectPointerLayout<CString>()

        /// The protocol the param is constrained to.
        ///
        /// Only valid if the requirement has Protocol kind.
        RelativeProtocolDescriptorPointerLayout()

        /// The conformance the param is constrained to use.
        ///
        /// Only valid if the requirement has SameConformance kind.
        RelativeIndirectablePointerLayout<RelativeDirectPointerLayout<ProtocolConformanceDescriptorLayout>>()

        /// The kind of layout constraint.
        ///
        /// Only valid if the requirement has Layout kind.
        NewTypeConstant<GenericRequirementLayoutKind>()
      }
    }
  }
}


/// Reference to a generic context.
struct GenericContextLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      // This struct is supposed to be empty, but TrailingObjects respects the
      // unique-address-per-object C++ rule, so even if this type is empty, the
      // trailing objects will come after one byte of padding. This dummy field
      // takes up space to make the offset of the trailing objects portable.
      Constant<UInt32>()

      /*
       TrailingGenericContextObjects<TargetGenericContext<Runtime>,
       TargetGenericContextDescriptorHeader>
       */
    }
  }
}

/// Descriptor for an extension context.
struct ExtensionContextDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      ContextDescriptorLayout()
      /// A mangling of the `Self` type context that the extension extends.
      /// The mangled name represents the type in the generic context encoded by
      /// this descriptor. For example, a nongeneric nominal type extension will
      /// encode the nominal type name. A generic nominal type extension will encode
      /// the instance of the type with any generic arguments bound.
      ///
      /// Note that the Parent of the extension will be the module context the
      /// extension is declared inside.
      RelativeDirectPointerLayout<CString>()
    }.withTrailingObjects {
      ExtensionContextDescriptorLayout()
    }
  }
}

struct MangledContextNameLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The mangled name of the context.
      RelativeDirectPointerLayout<CString>()
    }
  }
}

struct AnonymousContextDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      ContextDescriptorLayout()
      /*
       TrailingGenericContextObjects<TargetAnonymousContextDescriptor<Runtime>,
       TargetGenericContextDescriptorHeader,
       TargetMangledContextName<Runtime>>
       */
    }
  }
}

struct TypeContextDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      ContextDescriptorLayout()
      /// The name of the type.
      RelativeDirectPointerLayout<CString>()

      /// A pointer to the metadata access function for this type.
      ///
      /// The function type here is a stand-in. You should use getAccessFunction()
      /// to wrap the function pointer in an accessor that uses the proper calling
      /// convention for a given number of arguments.
      RelativeDirectPointerLayout<FunctionPointer<CVarArg, MetadataResponseLayout>>()

      /// A pointer to the field descriptor for the type, if any.
      RelativeDirectPointerLayout<FieldDescriptorLayout>()
    }
  }
}


