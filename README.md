# SwiftGestalt
 
SwiftGestalt is a family of libraries for interacting with the Swift runtime and Swift runtime
metadata.  The project is intended to support native Swift tooling that needs access to
runtime information, and to help demystify the internal machinations of the Swift runtime.

# Development Status

SwiftGestalt is currently profoundly incomplete and messy and comes with an enormous
amount of caveats.  It is not only **not ready for production**, it will probably take a lot of 
work to get it into a state where one could reasonably call it "pre-alpha".   Some 
notably unimplemented pieces:

- [ ] `ByteReader` should actually read `MetadataLayout` hierarchies
- [ ] `MetadataLayout` conformances for root structures needs to be fleshed out
- [ ] `ByteReader` should absolutely be lazy by design
- [ ] A user-facing entrypoint for querying the metadata associated with a metatype value at runtime should be available
- [ ] Bindings to `swift demangle` need to be explored *without hacks and compromises* (that includes linking libSwiftDemangle)
- [ ] Much, much better documentation
- [ ] Moving away from LLVM for object file introspection (this blocks iOS support)
- [ ] No longer lying to SwiftPM to "un-quarantine" targets
- [ ] Exploration of evolution proposals to support all of the above

# System Requirements

SwiftGestalt currently requires Swift 5.1, which requires an Xcode 11 beta.  In addition,
a checkout of [the Swift compiler](https://github.com/apple/swift) is required and an installation
of `llvm` must be installed, preferably from brew.  To obtain Swift, 
see the [Swift README](https://github.com/apple/swift/blob/master/README.md).  To 
obtain LLVM, invoke

```
brew install llvm
```

# Building

SwiftGestalt builds with the Swift Package Manager but also requires an additional 
pre-installation step. Clone the repository and run the following commands at its root.

```bash
swift ./utils/make-pkgconfig.swift /Path/To/Swift/Checkout/
swift build
```

# License

SwiftGestalt is released under the MIT License, a copy of which is available in this
repository.

# Contributing

We welcome contributions from programmers of all backgrounds and experience
levels. We've strived to create an environment that encourages learning through
contribution, and we pledge to always treat contributors with the respect they
deserve. We have adopted the Contributor Covenant as our code of conduct,
which can be read in this repository.

For more info, and steps for a successful contribution, see the
[Contribution Guide](.github/CONTRIBUTING.md).

# Authors

Robert Widmann ([@CodaFi](https://github.com/codafi))
