cmake_minimum_required(VERSION 2.8)
project(openssl)
include(flags OPTIONAL)
########################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enables MSVC Solution Folders
add_definitions(-DOPENSSL_NO_ASM)
if(WIN32 AND NOT CYGWIN)
  add_definitions(-DOPENSSL_SYSNAME_WIN32)
  add_definitions(-DWIN32_LEAN_AND_MEAN)
endif()
########################################
# headers to openssl (for build)
add_custom_command(OUTPUT ossl_hdrs_cmd
  COMMAND ${CMAKE_COMMAND} -Dsrc:STRING="e_os2.h"
    -DsrcDir:PATH=${openssl_SOURCE_DIR}
    -Ddst:PATH=${CMAKE_BINARY_DIR}/openssl -P ${openssl_SOURCE_DIR}/cpln.cmake
  )
add_custom_target(ossl_hdrs DEPENDS ossl_hdrs_cmd SOURCES cpln.cmake)
set_property(TARGET ossl_hdrs PROPERTY FOLDER openssl_h)
########################################
add_subdirectory(crypto)
add_subdirectory(ssl)
install(FILES e_os2.h DESTINATION include/openssl)
set(misc
  FAQ
  LICENSE
  PROBLEMS
  README
  README.ASN1
  README.ENGINE
  )
install(FILES ${misc} DESTINATION share/openssl)
install(FILES ${PROJECT_NAME}-config.cmake DESTINATION share/cmake)
install(EXPORT ${PROJECT_NAME}-targets DESTINATION share/cmake)
