/// main.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

let args = Array(CommandLine.arguments.dropFirst())
let potentialSubtool = args.first ?? ""
switch potentialSubtool {
case "demangle":
  SwiftGestaltDemangleTool(Array(args.dropFirst())).run()
case "interface":
  SwiftGestaltInterfaceTool(args: args).run()
case "dump":
  SwiftGestaltDumpTool(args: args).run()
default:
  SwiftGestaltDumpTool(args: args).run()
}
