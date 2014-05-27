# OPENSSL_FOUND - OpenSSL was found
# OPENSSL_INCLUDE_DIR - the OpenSSL include directory
# OPENSSL_LIBRARIES - the OpenSSL libraries
set(prj openssl)
get_filename_component(SELF_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include(${SELF_DIR}/${prj}-targets.cmake)
string(TOUPPER ${prj} PRJ)
get_filename_component(${PRJ}_INCLUDE_DIR "${SELF_DIR}/../../include" ABSOLUTE)
set(${PRJ}_LIBRARIES crypto ssl)
find_package_handle_standard_args(${prj}
  REQUIRED_VARS
    ${PRJ}_INCLUDE_DIR
    ${PRJ}_LIBRARIES
  )
mark_as_advanced(${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
