/// Dump.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

import Foundation
import Basic
import SPMUtility
import SwiftGestalt
import SwiftRuntime

public final class DumpToolOptions: SwiftGestaltToolOptions {
  public var colorsEnabled: Bool = false
  public var inputURLs: [Foundation.URL] = []
}

public class SwiftGestaltDumpTool: SwiftGestaltTool<DumpToolOptions> {
  public convenience init(args: [String]) {
    self.init(
      toolName: "Dump",
      usage: "[options]",
      overview: "Dump Swift runtime metadata",
      args: args
    )
  }

  private func printDumpHeader<T: TextOutputStream>(_ value: String, to stream: inout T) {
    stream.write("================DUMPING: \(value)====================")
    stream.write("\n")
  }

  override func runImpl() throws {
    var stdout = Basic.stdoutStream
    let context = ReflectionContext()
    for url in self.options.inputURLs {
      _ = context.addImage(url)
    }

    printDumpHeader("Field Metadata", to: &stdout)
    for descriptor in context.fieldDescriptors {
      descriptor.dump(to: &stdout)
    }

    printDumpHeader("Associated Type Metadata", to: &stdout)
    for descriptor in context.associatedTypeDescriptors {
      descriptor.dump(to: &stdout)
    }

    self.printDumpHeader("Symbols", to: &stdout)
    for file in context.objectFiles {
      for symbol in file.symbols {
        stdout.write(Demangler.demangleSymbol(symbol.name))
        stdout.write("\n")
      }
    }
  }

  override class func defineArguments(
    parser: ArgumentParser,
    binder: ArgumentBinder<DumpToolOptions>
  ) {
    binder.bindArray(
      positional: parser.add(
        positional: "",
        kind: [String].self,
        usage: "One or more input file(s)",
        completion: .filename),
      to: { opt, fs in
        let url = fs.map(URL.init(fileURLWithPath:))
        return opt.inputURLs.append(contentsOf: url)
    })
  }
}

extension FieldDescriptor {
  public func dump<T: TextOutputStream>(to stream: inout T) {
    var inEnum = false
    var isClassBound = false
    switch self.kind {
    case .`struct`:
      stream.write("struct ")
    case .`class`:
      stream.write("class ")
    case .`enum`:
      stream.write("enum ")
      inEnum = true
    case .multiPayloadEnum:
      stream.write("enum ")
      inEnum = true
    case .`protocol`:
      stream.write("protocol ")
    case .classProtocol:
      stream.write("protocol ")
      isClassBound = true
    case .objCProtocol:
      stream.write("@objc protocol ")
    case .objCClass:
      stream.write("@objc class ")
    }

    let demangledName = postprocessDemangledName(_stdlib_demangleName(self.mangledTypeName))
    stream.write(demangledName)
    if isClassBound {
      stream.write(" : class")
    }
    stream.write(" {")
    stream.write("\n")
    for field in self.fields {
      stream.write("  ")
      if inEnum {
        stream.write(" case")
      } else {
        stream.write(" \(field.flags.contains(.IsVar) ? "var" : "let")")
      }
      stream.write(" \(field.fieldName)")

      guard !field.mangledTypeName.isEmpty else {
        stream.write("\n")
        continue
      }
      stream.write(" : \(postprocessDemangledName(_stdlib_demangleName(field.mangledTypeName)))")
      stream.write("\n")
    }
    stream.write("}")
    stream.write("\n")
  }
}

extension AssociatedTypeDescriptor {
  public func dump<T: TextOutputStream>(to stream: inout T) {
    stream.write("extension \(postprocessDemangledName(conformingTypeName)) : \(protocolTypeName) {")
    stream.write("\n")
    for record in self.records {
      stream.write("  typealias \(record.name) = \(record.substitutedTypeName)")
      stream.write("\n")
    }
    stream.write("}")
    stream.write("\n")
  }
}

func postprocessDemangledName(_ name: String) -> String {
  if name.starts(with: "(extension in") {
    return String(name.drop(while: { $0 != ":" }).dropFirst())
  }

  return name.replacingOccurrences(of: "__C", with: "")
}
