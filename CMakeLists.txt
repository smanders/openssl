cmake_minimum_required(VERSION 3.12)
project(openssl)
include(flags OPTIONAL)
########################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enables MSVC Solution Folders
add_definitions(
  -DOPENSSL_NO_ASM
  -DOPENSSL_THREADS
  -D_REENTRANT
  )
if(WIN32)
  add_definitions(
    -DOPENSSL_SYS_WIN32
    -DOPENSSL_NO_AFALGENG
    -DWIN32_LEAN_AND_MEAN
    -DUNICODE -D_UNICODE
    -D_CRT_SECURE_NO_DEPRECATE
    -D_WINSOCK_DEPRECATED_NO_WARNINGS
    )
endif()
########################################
function(compareCmakeFilesys files)
  file(GLOB_RECURSE filesys RELATIVE ${CMAKE_CURRENT_LIST_DIR} *)
  file(GLOB_RECURSE ignorefiles RELATIVE ${CMAKE_CURRENT_LIST_DIR} .*.swp)
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
add_subdirectory(include)
add_subdirectory(crypto)
add_subdirectory(ssl)
add_subdirectory(test)
if(DEFINED XP_NAMESPACE)
  set(nameSpace NAMESPACE ${XP_NAMESPACE}::)
endif()
install(EXPORT ${targetsFile} DESTINATION lib/cmake ${nameSpace})
