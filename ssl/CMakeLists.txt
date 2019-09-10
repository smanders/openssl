set(lib_name ssl)
########################################
# root
set(root_srcs # order from ssl/build.info
  build.info
  pqueue.c
  packet.c
  s3_lib.c
  s3_enc.c
  s3_cbc.c
  s3_msg.c
  methods.c
  t1_lib.c
  t1_enc.c
  tls13_enc.c
  d1_lib.c
  d1_msg.c
  d1_srtp.c
  ssl_lib.c
  ssl_cert.c
  ssl_sess.c
  ssl_ciph.c
  ssl_stat.c
  ssl_rsa.c
  ssl_asn1.c
  ssl_txt.c
  ssl_init.c
  ssl_conf.c
  ssl_mcnf.c
  bio_ssl.c
  ssl_err.c
  tls_srp.c
  t1_trce.c
  ssl_utst.c
  )
list(APPEND root_srcs
  packet_locl.h
  ssl_cert_table.h
  ssl_locl.h
  )
source_group("" FILES ${root_srcs})
list(APPEND ${lib_name}_libsrcs ${root_srcs})
##########
set(root_extra # in directory, not in build.info
  CMakeLists.txt
  )
list(APPEND ${lib_name}_all ${root_extra})
####################
# record
set(record_srcs # order from ssl/build.info
  record/rec_layer_s3.c
  record/rec_layer_d1.c
  record/ssl3_buffer.c
  record/ssl3_record.c
  record/dtls1_bitmap.c
  record/ssl3_record_tls13.c
  )
list(APPEND record_srcs
  record/README
  record/record.h
  record/record_locl.h
  )
source_group(record FILES ${record_srcs})
list(APPEND ${lib_name}_libsrcs ${record_srcs})
####################
# statem
set(statem_srcs # order from ssl/build.info
  statem/statem_srvr.c
  statem/statem_clnt.c
  statem/statem_lib.c
  statem/extensions.c
  statem/extensions_srvr.c
  statem/extensions_clnt.c
  statem/extensions_cust.c
  statem/statem_dtls.c
  statem/statem.c
  )
list(APPEND statem_srcs
  statem/README
  statem/statem.h
  statem/statem_locl.h
  )
source_group(statem FILES ${statem_srcs})
list(APPEND ${lib_name}_libsrcs ${statem_srcs})
########################################
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
if(FALSE) # cmake bugs with INTERFACE library
# TODO: EXPORT of STATIC library with PRIVATE non-target dependencies broken
# https://gitlab.kitware.com/cmake/cmake/issues/17357
# I'm seeing the same error reported in this issue
target_link_libraries(${lib_name} PRIVATE include)
else()
target_include_directories(${lib_name} PRIVATE
  ${CMAKE_SOURCE_DIR}/include
  ${CMAKE_BINARY_DIR}/include # e_os.h, openssl/opensslconf.h
  )
endif()
target_link_libraries(${lib_name} PUBLIC crypto)
set_target_properties(${lib_name} PROPERTIES OUTPUT_NAME ${lib_name}${ver})
########################################
install(TARGETS ${lib_name} EXPORT ${targetsFile}
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )
########################################
list(APPEND ${lib_name}_all ${${lib_name}_libsrcs})
compareCmakeFilesys("${${lib_name}_all}")
