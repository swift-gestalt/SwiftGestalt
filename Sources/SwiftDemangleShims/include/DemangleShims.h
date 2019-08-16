#include <stddef.h>

#ifndef SWIFT_DEMANGLE_SHIM_H
#define SWIFT_DEMANGLE_SHIM_H

const char *SDSDemangleTypeAsString(const char *MangledName, size_t Length,
                                    size_t *OutLength);

#endif /* SWIFT_DEMANGLE_SHIM_H */
