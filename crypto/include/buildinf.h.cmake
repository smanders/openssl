/*
 * WARNING: do not edit!
 * Generated by CMakeLists.txt from crypto/include/buildinf.h.cmake
 * (cmake version of util/mkbuildinf.pl)
 *
 * Copyright 2014-2017 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#define PLATFORM "platform: @BUILDINF_PLATFORM@"
#define DATE "built on: @BUILDINF_DATE@"

/*
 * Generate compiler_flags as an array of individual characters. This is a
 * workaround for the situation where CFLAGS gets too long for a C90 string
 * literal
 */
static const char compiler_flags[] = {@BUILDINF_COMPILER_FLAGS@
};
