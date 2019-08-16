/// ClassDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

struct ResilientSuperclassLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The superclass of this class.  This pointer can be interpreted
      /// using the superclass reference kind stored in the type context
      /// descriptor flags.  It is null if the class has no formal superclass.
      ///
      /// Note that SwiftObject, the implicit superclass of all Swift root
      /// classes when building with ObjC compatibility, does not appear here.
      OpaqueRelativeDirectPointerLayout()
    }
  }
}

/// A structure that stores a reference to an Objective-C class stub.
///
/// This is not the class stub itself it is part of a class context
/// descriptor.
struct ObjCResilientClassStubInfoLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// A relative pointer to an Objective-C resilient class stub.
      ///
      /// We do not declare a struct type for class stubs since the Swift runtime
      /// does not need to interpret them. The class stub struct is part of
      /// the Objective-C ABI, and is laid out as follows:
      /// - isa pointer, always 1
      /// - an update callback, of type 'Class (*)(Class *, objc_class_stub *)'
      ///
      /// Class stubs are used for two purposes:
      ///
      /// - Objective-C can reference class stubs when calling static methods.
      /// - Objective-C and Swift can reference class stubs when emitting
      ///   categories (in Swift, extensions with @objc members).
      OpaqueRelativeDirectPointerLayout()
    }
  }
}

struct ExtraClassDescriptorFlags: OptionSet {
  var rawValue: UInt32

  /// Set if the context descriptor includes a pointer to an Objective-C
  /// resilient class stub structure. See the description of
  /// TargetObjCResilientClassStubInfo in Metadata.h for details.
  ///
  /// Only meaningful for class descriptors when Objective-C interop is
  /// enabled.
  static let hasObjCResilientClassStub = ExtraClassDescriptorFlags(rawValue: 0)
}

/// Storage for class metadata bounds.  This is the variable returned
/// by getAddrOfClassMetadataBounds in the compiler.
///
/// This storage is initialized before the allocation of any metadata
/// for the class to which it belongs.  In classes without resilient
/// superclasses, it is initialized statically with values derived
/// during compilation.  In classes with resilient superclasses, it
/// is initialized dynamically, generally during the allocation of
/// the first metadata of this class's type.  If metadata for this
/// class is available to you to use, you must have somehow synchronized
/// with the thread which allocated the metadata, and therefore the
/// complete initialization of this variable is also ordered before
/// your access.  That is why you can safely access this variable,
/// and moreover access it without further atomic accesses.  However,
/// since this variable may be accessed in a way that is not dependency-
/// ordered on the metadata pointer, it is important that you do a full
/// synchronization and not just a dependency-ordered (consume)
/// synchronization when sharing class metadata pointers between
/// threads.  (There are other reasons why this is true for example,
/// field offset variables are also accessed without dependency-ordering.)
///
/// If you are accessing this storage without such a guarantee, you
/// should be aware that it may be lazily initialized, and moreover
/// it may be getting lazily initialized from another thread.  To ensure
/// correctness, the fields must be read in the correct order: the
/// immediate-members offset is initialized last with a store-release,
/// so it must be read first with a load-acquire, and if the result
/// is non-zero then the rest of the variable is known to be valid.
/// (No locking is required because racing initializations should always
/// assign the same values to the storage.)
struct StoredClassMetadataBoundsLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The offset to the immediate members.  This value is in bytes so that
      /// clients don't have to sign-extend it.
      Constant<Int>()

      /// The positive and negative bounds of the class metadata.
      MetadataBoundsLayout()
    }
  }
}

struct ClassDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }

  var layout: some MetadataLayout { 
    Metadata {
      TypeContextDescriptorLayout()

      /// The type of the superclass, expressed as a mangled type name that can
      /// refer to the generic arguments of the subclass type.
      RelativeDirectPointerLayout<CString>()

      Union {
        /// If this descriptor does not have a resilient superclass, this is the
        /// negative size of metadata objects of this class (in words).
        Constant<UInt32>()

        /// If this descriptor has a resilient superclass, this is a reference
        /// to a cache holding the metadata's extents.
        RelativeDirectPointerLayout<StoredClassMetadataBoundsLayout>()
      }

      Union {
        /// If this descriptor does not have a resilient superclass, this is the
        /// positive size of metadata objects of this class (in words).
        Constant<UInt32>()

        /// Otherwise, these flags are used to do things like indicating
        /// the presence of an Objective-C resilient class stub.
        Flags<ExtraClassDescriptorFlags>()
      }

      /// The number of additional members added by this class to the class
      /// metadata.  This data is opaque by default to the runtime, other than
      /// as exposed in other members it's really just
      /// NumImmediateMembers * sizeof(void*) bytes of data.
      ///
      /// Whether those bytes are added before or after the address point
      /// depends on areImmediateMembersNegative().
      Constant<UInt32>()

      /// The number of stored properties in the class, not including its
      /// superclasses. If there is a field offset vector, this is its length.
      Constant<UInt32>()

      /// The offset of the field offset vector for this class's stored
      /// properties in its metadata, in words. 0 means there is no field offset
      /// vector.
      ///
      /// If this class has a resilient superclass, this offset is relative to
      /// the size of the resilient superclass metadata. Otherwise, it is
      /// absolute.
      Constant<UInt32>()
    }
    .withTrailingObjects {
      TypeGenericContextDescriptorHeaderLayout()
      ResilientSuperclassLayout()
      ForeignMetadataInitializationLayout()
      SingletonMetadataInitializationLayout()
      VTableDescriptorHeaderLayout()
      MethodDescriptorLayout()
      OverrideTableHeaderLayout()
      MethodOverrideDescriptorLayout()
      ObjCResilientClassStubInfoLayout()
    }
  }
}
