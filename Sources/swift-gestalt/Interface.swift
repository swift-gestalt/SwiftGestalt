/// Interface.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

import Foundation
import Basic
import SPMUtility
import SwiftGestalt

public final class InterfaceToolOptions: SwiftGestaltToolOptions {
  public var colorsEnabled: Bool = false
  public var inputURLs: [Foundation.URL] = []
}

public class SwiftGestaltInterfaceTool: SwiftGestaltTool<InterfaceToolOptions> {
  public convenience init(args: [String]) {
    self.init(
      toolName: "interface",
      usage: "[options]",
      overview: "Build an interface from Swift runtime metadata",
      args: args
    )
  }

  override func runImpl() throws {
    let context = ReflectionContext()
    for url in self.options.inputURLs {
      _ = context.addImage(url)
    }

    
  }

  override class func defineArguments(
    parser: ArgumentParser,
    binder: ArgumentBinder<InterfaceToolOptions>
  ) {
    binder.bind(
      option: parser.add(option: "--color-diagnostics", kind: Bool.self),
      to: { opt, r in opt.colorsEnabled = r })
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
