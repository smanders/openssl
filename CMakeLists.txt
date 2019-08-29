cmake_minimum_required(VERSION 3.0)
project(openssl)
include(flags OPTIONAL)
########################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enables MSVC Solution Folders
add_definitions(-DOPENSSL_NO_ASM)
add_definitions(-DOPENSSL_THREADS -D_REENTRANT)
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
function(compareCmakeFilesys files)
  file(GLOB_RECURSE filesys RELATIVE ${CMAKE_CURRENT_LIST_DIR} *)
  # the git repo is littered with .cvsignore files (which the tarball doesn't have)
  # the tar.gz file has a crypto/opensslconf.h file (which the git repo doesn't have)
  file(GLOB_RECURSE ignorefiles RELATIVE ${CMAKE_CURRENT_LIST_DIR} .cvsignore opensslconf.h)
  if(ignorefiles)
    list(REMOVE_ITEM filesys ${ignorefiles})
  endif()
  foreach(f ${filesys})
    list(FIND files ${f} index)
    if(${index} GREATER -1)
      list(REMOVE_AT files ${index})
      list(REMOVE_ITEM filesys ${f})
    endif()
  endforeach()
  if(filesys)
    message(FATAL_ERROR "files not in cmake: ${filesys}")
  endif()
  if(files)
    message(FATAL_ERROR "files not in repo, but in cmake: ${files}")
  endif()
endfunction()
########################################
if(DEFINED OPENSSL_VER)
  set(ver _${OPENSSL_VER})
  set(verDir /${PROJECT_NAME}${ver})
endif()
set(targetsFile ${PROJECT_NAME}${ver}-targets)
########################################
add_subdirectory(crypto)
add_subdirectory(ssl)
install(FILES e_os2.h DESTINATION include${verDir}/${PROJECT_NAME})
set(misc
  FAQ
  LICENSE
  PROBLEMS
  README
  README.ASN1
  README.ENGINE
  )
install(FILES ${misc} DESTINATION share${verDir}/openssl)
install(EXPORT ${targetsFile} DESTINATION lib/cmake)
