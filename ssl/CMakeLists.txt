set(lib_name ssl)
set(lib_deps crypto)
########################################
include_directories(
  ${openssl_SOURCE_DIR}
  ${openssl_BINARY_DIR} # openssl/*.h
  ${openssl_SOURCE_DIR}/crypto # o_dir.h
  )
####################
# root
set(root_srcs # order from ssl/Makefile
  s2_meth.c
  s2_srvr.c
  s2_clnt.c
  s2_lib.c
  s2_enc.c
  s2_pkt.c
  s3_meth.c
  s3_srvr.c
  s3_clnt.c
  s3_lib.c
  s3_enc.c
  s3_pkt.c
  s3_both.c
  s3_cbc.c
  s23_meth.c
  s23_srvr.c
  s23_clnt.c
  s23_lib.c
  s23_pkt.c
  t1_meth.c
  t1_srvr.c
  t1_clnt.c
  t1_lib.c
  t1_enc.c
  d1_meth.c
  d1_srvr.c
  d1_clnt.c
  d1_lib.c
  d1_pkt.c
  d1_both.c
  d1_enc.c
  d1_srtp.c
  ssl_lib.c
  ssl_err2.c
  ssl_cert.c
  ssl_sess.c
  ssl_ciph.c
  ssl_stat.c
  ssl_rsa.c
  ssl_asn1.c
  ssl_txt.c
  ssl_algs.c
  bio_ssl.c
  ssl_err.c
  kssl.c
  tls_srp.c
  t1_reneg.c
  )
set(root_exhdrs
  ssl.h
  ssl2.h
  ssl3.h
  ssl23.h
  tls1.h
  dtls1.h
  kssl.h
  srtp.h
  )
list(APPEND root_srcs
  ${root_exhdrs}
  ssl_locl.h
  kssl_lcl.h
  install-ssl.com
  Makefile
  ssl-lib.com
  #ssl_task.c # in directory, not in Makefile
  #ssltest.c  # in directory, not in LIBSRC
  )
source_group("" FILES ${root_srcs})
list(APPEND ${lib_name}_libsrcs ${root_srcs})
list(APPEND ${lib_name}_exhdrs ${root_exhdrs})
########################################
# headers to openssl (for build)
add_custom_command(OUTPUT ${lib_name}_hdrs_cmd
  COMMAND ${CMAKE_COMMAND} -Dsrc:STRING="${${lib_name}_exhdrs}"
    -DsrcDir:PATH=${CMAKE_CURRENT_SOURCE_DIR}
    -Ddst:PATH=${CMAKE_BINARY_DIR}/openssl -P ${openssl_SOURCE_DIR}/cpln.cmake
  )
add_custom_target(${lib_name}_hdrs
  DEPENDS ${lib_name}_hdrs_cmd
  SOURCES ${openssl_SOURCE_DIR}/cpln.cmake
  )
set_property(TARGET ${lib_name}_hdrs PROPERTY FOLDER openssl_h)
########################################
# library
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
add_dependencies(${lib_name} ${lib_deps} ${lib_name}_hdrs)
target_link_libraries(${lib_name} ${lib_deps})
########################################
# install
install(TARGETS ${lib_name}
  RUNTIME DESTINATION bin${NUMBITS}
  LIBRARY DESTINATION lib${NUMBITS}
  ARCHIVE DESTINATION lib${NUMBITS}
  )
install(FILES ${${lib_name}_exhdrs} DESTINATION include/openssl)
