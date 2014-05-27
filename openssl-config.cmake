set(prj openssl)
get_filename_component(SELF_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include(${SELF_DIR}/${prj}-targets.cmake)
get_filename_component(${prj}_INCLUDE_DIRS "${SELF_DIR}/../../include/${prj}" ABSOLUTE)
