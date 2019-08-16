/// MethodDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

struct MethodDescriptorFlags: OptionSet {
  var rawValue: UInt32

  enum Kind: UInt {
    case method           = 0
    case initializer      = 1
    case getter           = 2
    case setter           = 3
    case modifyCoroutine  = 4
    case readCoroutine    = 5
  }

  static let kindMask = MethodDescriptorFlags(rawValue: 0x0F)
  static let isInstanceMask = MethodDescriptorFlags(rawValue: 0x10)
  static let isDynamicMask = MethodDescriptorFlags(rawValue: 0x20)
}

/// An opaque descriptor describing a class or protocol method. References to
/// these descriptors appear in the method override table of a class context
/// descriptor, or a resilient witness table pattern, respectively.
///
/// Clients should not assume anything about the contents of this descriptor
/// other than it having 4 byte alignment.
struct MethodDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Flags describing the method.
      Flags<MethodDescriptorFlags>()
      /// The method implementation.
      OpaqueRelativeDirectPointerLayout()
    }
  }
}

/// Header for a class vtable descriptor. This is a variable-sized
/// structure that describes how to find and parse a vtable
/// within the type metadata for a class.
struct VTableDescriptorHeaderLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The offset of the vtable for this class in its metadata, if any,
      /// in words.
      ///
      /// If this class has a resilient superclass, this offset is relative to the
      /// the start of the immediate class's metadata. Otherwise, it is relative
      /// to the metadata address point.
      Constant<UInt32>()

      /// The number of vtable entries. This is the number of MethodDescriptor
      /// records following the vtable header in the class's nominal type
      /// descriptor, which is equal to the number of words this subclass's vtable
      /// entries occupy in instantiated class metadata.
      Constant<UInt32>()
    }
  }
}

/// An entry in the method override table, referencing a method from one of our
/// ancestor classes, together with an implementation.
struct MethodOverrideDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The class containing the base method.
      RelativeIndirectablePointerLayout<ClassDescriptorLayout>()
      /// The base method.
      RelativeIndirectablePointerLayout<MethodDescriptorLayout>()
      /// The implementation of the override.
      OpaqueRelativeDirectPointerLayout()
    }
  }
}

/// Header for a class vtable override descriptor. This is a variable-sized
/// structure that provides implementations for overrides of methods defined
/// in superclasses.
struct OverrideTableHeaderLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The number of MethodOverrideDescriptor records following the vtable
      /// override header in the class's nominal type descriptor.
      Constant<UInt32>()
    }
  }
}
