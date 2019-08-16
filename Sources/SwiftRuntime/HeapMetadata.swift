/// HeapMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

typealias HeapObjectDestroyer = FunctionPointer<(OpaquePointer), ()>

struct HeapMetadataHeaderPrefixLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Destroy the object, returning the allocated size of the object
      /// or 0 if the object shouldn't be deallocated.
      ///
      /// using HeapObjectDestroyer =
      ///     SWIFT_CC(swift) void(SWIFT_CONTEXT HeapObject *)
      HeapObjectDestroyer()
    }
  }
}

/// The common structure of all metadata for heap-allocated types.  A
/// pointer to one of these can be retrieved by loading the 'isa'
/// field of any heap object, whether it was managed by Swift or by
/// Objective-C.  However, when loading from an Objective-C object,
/// this metadata may not have the heap-metadata header, and it may
/// not be the Swift type metadata for the object's dynamic type.
struct HeapMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      HeapMetadataHeaderPrefixLayout()
      TypeMetadataHeaderLayout()
    }
  }
}

/// The structure of metadata for heap-allocated local variables.
/// This is non-type metadata.
struct HeapLocalVariableMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      HeapMetadataLayout()
      Constant<UInt32>()
      // FIXME: Add String type(s) to DSL?
      DirectPointer<CString>()
    }
  }
}

/// Heap metadata for a box, which may have been generated statically by the
/// compiler or by the runtime.
struct BoxHeapMetadata : MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      HeapMetadataLayout()
      /// The offset from the beginning of a box to its value.
      Constant<UInt32>()
    }
  }
}

/// Heap metadata for runtime-instantiated generic boxes.
struct GenericBoxHeapMetadata : MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      BoxHeapMetadata()
      /// The type inside the box.
      DirectPointer<SwiftMetadataLayout>()
    }
  }
}
