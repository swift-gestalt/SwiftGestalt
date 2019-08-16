/// ClassMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The portion of a class metadata object that is compatible with
/// all classes, even non-Swift ones.
struct AnyClassMetadataLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      HeapMetadataLayout()
      /// The metadata for the superclass.  This is null for the root class.
      DirectPointer<ClassMetadataLayout>()

      /// The cache data is used for certain dynamic lookups it is owned
      /// by the runtime and generally needs to interoperate with
      /// Objective-C's use.
      WordBuffer2Layout()

      /// The data pointer is used for out-of-line metadata and is
      /// generally opaque, except that the compiler sets the low bit in
      /// order to indicate that this is a Swift metatype and therefore
      /// that the type metadata header is present.
      Constant<Int>()
    }
  }
}

//using ClassIVarDestroyer =
//  SWIFT_CC(swift) void(SWIFT_CONTEXT HeapObject *)
typealias ClassIVarDestroyer = FunctionPointer<OpaquePointer, ()>

/// The structure of all class metadata.  This structure is embedded
/// directly within the class's heap metadata structure and therefore
/// cannot be extended without an ABI break.
///
/// Note that the layout of this type is compatible with the layout of
/// an Objective-C class.
struct ClassMetadataLayout: MetadataLayout {
  /// Swift class flags.
  /// These flags are valid only when isTypeMetadata().
  /// When !isTypeMetadata() these flags will collide with other Swift ABIs.
  struct ClassFlags : OptionSet {
    var rawValue: UInt32

    /// Is this a Swift class from the Darwin pre-stable ABI?
    /// This bit is clear in stable ABI Swift classes.
    /// The Objective-C runtime also reads this bit.
    static let isSwiftPreStableABI = ClassFlags(rawValue: 1 << 0)

    /// Does this class use Swift refcounting?
    static let usesSwiftRefcounting = ClassFlags(rawValue: 1 << 1)

    /// Has this class a custom name, specified with the @objc attribute?
    static let hasCustomObjCName = ClassFlags(rawValue: 1 << 2)
  }

  var layout: some DerivedMetadataLayout {
    Metadata {
      AnyClassMetadataLayout()
      // The remaining fields are valid only when isTypeMetadata().
      // The Objective-C runtime knows the offsets to some of these fields.
      // Be careful when accessing them.

      /// Swift-specific class flags.
      Flags<ClassFlags>()

      /// The address point of instances of this type.
      Constant<UInt32>()

      /// The required size of instances of this type.
      /// 'InstanceAddressPoint' bytes go before the address point
      /// 'InstanceSize - InstanceAddressPoint' bytes go after it.
      Constant<UInt32>()

      /// The alignment mask of the address point of instances of this type.
      Constant<UInt16>()

      /// Reserved for runtime use.
      Constant<UInt16>()

      /// The total size of the class object, including prefix and suffix
      /// extents.
      Constant<UInt32>()

      /// The offset of the address point within the class object.
      Constant<UInt32>()

      /// An out-of-line Swift-specific description of the type, or null
      /// if this is an artificial subclass.  We currently provide no
      /// supported mechanism for making a non-artificial subclass
      /// dynamically.
      DirectPointer<ClassDescriptorLayout>()

      /// A function for destroying instance variables, used to clean up after an
      /// early return from a constructor. If null, no clean up will be performed
      /// and all ivars must be trivial.
      ClassIVarDestroyer()

      // After this come the class members, laid out as follows:
      //   - class members for the superclass (recursively)
      //   - metadata reference for the parent, if applicable
      //   - generic parameters for this class
      //   - class variables (if we choose to support these)
      //   - "tabulated" virtual methods
    }
  }
}

/// The structure of wrapper metadata for Objective-C classes.  This
/// is used as a type metadata pointer when the actual class isn't
/// Swift-compiled.
struct ObjCClassWrapperMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      SwiftMetadataLayout()
      DirectPointer<ClassMetadataLayout>()
    }
  }
}
