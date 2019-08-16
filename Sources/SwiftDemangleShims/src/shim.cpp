#include "swift/SwiftRemoteMirror/SwiftRemoteMirror.h"
#include "swift/SwiftRemoteMirror/Platform.h"
#include "swift/Demangling/TypeDecoder.h"

#include "runtime/Private.h"
#include <stdlib.h>
#include <string>

extern "C" {
  const char *SDSDemangleTypeAsString(const char *MangledName, size_t Length,
                                      size_t *OutLength);
}

namespace llvm {
  int EnableABIBreakingChecks = 1;
}

const char *SDSDemangleTypeAsString(const char *MangledName, size_t Length,
                                    size_t *OutLength) {
  StringRef Mangled{MangledName, Length};

  Demangler Dem;
 // Dem.setSymbolicReferenceResolver(swift::ResolveToDemanglingForContext(Dem));

  auto Demangled = Dem.demangleType(dropSwiftManglingPrefix(Mangled));
  auto TypeName = nodeToString(Demangled);
  *OutLength = TypeName.size();
  return strndup(TypeName.data(), TypeName.size());
}
