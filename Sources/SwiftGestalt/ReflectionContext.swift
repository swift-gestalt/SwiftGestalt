/// ReflectionContext.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

import Foundation
import LLVM
import SwiftRuntime
import SwiftDemangleShims

public enum ReflectionError: Error {
  case generic
}

public final class ReflectionContext {
  public private(set) var objectFiles: [ObjectFile]
  public private(set) var fieldDescriptors: [FieldDescriptor]
  public private(set) var associatedTypeDescriptors: [AssociatedTypeDescriptor]

  public struct Sections {
    public let fields: Section?
    public let associatedTypes: Section?
    public let builtins: Section?
    public let captures: Section?
    public let reflectionStrings: Section?
    public let protocols: Section?
    public let protocolConformances: Section?
    public let typeReferences: Section?
    public let dynamicReplacement: Section?
    public let dynamicReplacement2: Section?
  }

  public private(set) var sections: Sections? = nil


  public init() {
    self.objectFiles = []
    self.fieldDescriptors = []
    self.associatedTypeDescriptors = []
  }

  deinit {
    self.objectFiles.removeAll()
  }

  public func addImage(_ url: URL) -> Result<(), ReflectionError> {
    do {
      let objectFile = try ObjectFile(path: url.path)
      self.readSwiftSections(objectFile)
      self.objectFiles.append(objectFile)
      return .success(())
    } catch let e {
      return .failure(.generic)
    }
  }

  private func readSwiftSections(_ file: ObjectFile) {
    var fieldMDSection: Section? = nil
    var assocMDSection: Section? = nil
    var builtinMDSection: Section? = nil
    var captureMDSection: Section? = nil
    var reflStringsMDSection: Section? = nil
    var protocolsMDSection: Section? = nil
    var protocolConformancesMDSection: Section? = nil
    var typeReferencesSection: Section? = nil
    var dynamicReplacementSection: Section? = nil
    var dynamicReplacement2Section: Section? = nil


    for section in file.sections {
      switch section.name {
      case let x where x.starts(with: "__swift5_fieldmd"):
        fieldMDSection = section
      case let x where x.starts(with: "__swift5_assocty"):
        assocMDSection = section
      case let x where x.starts(with: "__swift5_builtin"):
        builtinMDSection = section
      case let x where x.starts(with: "__swift5_capture"):
        captureMDSection = section
      case let x where x.starts(with: "__swift5_reflstr"):
        reflStringsMDSection = section
      case let x where x.starts(with: "__swift5_protos"):
        protocolsMDSection = section
      case let x where x.starts(with: "__swift5_proto"):
        protocolConformancesMDSection = section
      case let x where x.starts(with: "__swift5_types"):
        typeReferencesSection = section
      case let x where x.starts(with: "__swift5_replace"):
        dynamicReplacementSection = section
      case let x where x.starts(with: "__swift5_replac2"):
        dynamicReplacement2Section = section
      default:
        continue
      }

      self.sections = Sections(
        fields: fieldMDSection,
        associatedTypes: assocMDSection,
        builtins: builtinMDSection,
        captures: captureMDSection,
        reflectionStrings: reflStringsMDSection,
        protocols: protocolsMDSection,
        protocolConformances: protocolConformancesMDSection,
        typeReferences: typeReferencesSection,
        dynamicReplacement: dynamicReplacementSection,
        dynamicReplacement2: dynamicReplacement2Section)
    }

    self.readSwiftFieldMetadata(file, fieldMDSection!, typeReferencesSection!, reflStringsMDSection!)
    self.readSwiftAssociatedTypeMetadata(file, assocMDSection!)

//    self.readSwiftAssociatedTypeMetadata(file, section)
//    self.readSwiftBuiltinTypeMetadata(file, section)
//    self.readSwiftCaptureSectionMetadata(file, section)
//    self.readSwiftTypeRefMetadata(file, section)
//    self.readSwiftReflectionStringsMetadata(file, section)
  }

  private func readSwiftFieldMetadata(_ file: ObjectFile, _ section: Section, _ typeRefSection: Section, _ reflStringSection: Section) {
    let contents = section.contents
    guard !contents.isEmpty else {
      return
    }

//    var offset = 0
//    while true {
//      let descriptor = FieldDescriptor.from(raw: contents.baseAddress!.advanced(by: offset))
//      self.fieldDescriptors.append(descriptor)
//
//      let off = MemoryLayout<FieldDescriptor.Raw>.size + (descriptor.numFields * descriptor.fieldRecordSize)
//      guard offset + off < contents.endIndex else {
//        return
//      }
//      offset += off
//    }
  }

  private func readSwiftAssociatedTypeMetadata(_ file: ObjectFile, _ section: Section) {
    let contents = section.contents
    guard !contents.isEmpty else {
      return
    }

    var offset = 0
//    while true {
      let descriptor = AssociatedTypeDescriptor.from(raw: contents)
      self.associatedTypeDescriptors.append(descriptor)

//      let off = MemoryLayout<AssociatedTypeDescriptor.Raw>.size + (descriptor.associatedTypeCount * descriptor.associatedTypeRecordSize)
//      guard offset + off < contents.endIndex else {
//        return
//      }
//      offset += off
//    }
  }

  private func readSwiftBuiltinTypeMetadata(_ file: ObjectFile, _ section: Section, _ symbol: Symbol? = nil) {
    print(section.contents)
  }

  private func readSwiftCaptureSectionMetadata(_ file: ObjectFile, _ section: Section, _ symbol: Symbol? = nil) {
    print(section.contents)
  }

  private func readSwiftTypeRefMetadata(_ file: ObjectFile, _ section: Section, _ symbol: Symbol? = nil) {
    print(section.contents)
  }

  private func readSwiftReflectionStringsMetadata(_ file: ObjectFile, _ section: Section, _ symbol: Symbol? = nil) {
    print(section.contents)
  }
}

