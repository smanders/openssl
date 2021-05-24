set(folder test)
########################################
# tests that depend on include
foreach(t
  rsa_complex
  shlibloadtest
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE include)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
target_include_directories(shlibloadtest PRIVATE ${CMAKE_BINARY_DIR}/crypto/include)
target_link_libraries(shlibloadtest PRIVATE ${CMAKE_DL_LIBS})
########################################
# tests that depend on crypto
foreach(t
  aborttest
  asynctest
  versions
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE crypto)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
########################################
# tests that depend on ssl
foreach(t
  ssltest_old
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE ssl)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
########################################
# testutil library
set(testutil_srcs
  testutil/basic_output.c
  testutil/cb.c
  testutil/driver.c
  testutil/format_output.c
  testutil/init.c
  testutil/main.c
  testutil/output.h
  testutil/output_helpers.c
  testutil/random.c
  testutil/stanza.c
  testutil/tap_bio.c
  testutil/test_cleanup.c
  testutil/tests.c
  testutil/tu_local.h
  testutil.h
  )
add_library(testutil STATIC ${testutil_srcs})
target_link_libraries(testutil PUBLIC crypto)
set_property(TARGET testutil PROPERTY FOLDER ${folder})
list(APPEND test_srcs ${testutil_srcs})
########################################
# tests that depend on testutil
foreach(t
  afalgtest
  asn1_decode_test
  asn1_encode_test
  asn1_string_table_test
  asn1_time_test
  bftest
  bio_callback_test
  bio_enc_test
  bio_memleak_test
  bioprinttest
  bntest
  casttest
  cmsapitest
  conf_include_test
  constant_time_test
  crltest
  ct_test
  d2i_test
  destest
  dhtest
  dsa_no_digest_size_test
  dsatest
  ecstresstest
  ectest
  enginetest
  errtest
  exdatatest
  exptest
  gmdifftest
  hmactest
  ideatest
  igetest
  lhash_test
  md2test
  mdc2_internal_test
  mdc2test
  memleaktest
  modes_internal_test
  ocspapitest
  packettest
  pbelutest
  pemtest
  pkey_meth_kdf_test
  pkey_meth_test
  rc2test
  rc4test
  rc5test
  rdrand_sanitytest
  rsa_mp_test
  rsa_test
  sanitytest
  secmemtest
  srptest
  ssl_cert_table_internal_test
  stack_test
  test_test
  threadstest
  time_offset_test
  v3ext
  v3nametest
  verify_extra_test
  x509aux
  x509_check_cert_pkey_test
  x509_dup_cert_test
  x509_internal_test
  x509_time_test
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE testutil)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
########################################
# tests that depend on testutil/ssl
foreach(t
  bad_dtls_test
  cipherbytes_test
  cipherlist_test
  ciphername_test
  cipher_overhead_test
  clienthellotest
  danetest
  dtlsv1listentest
  sysdefaulttest
  tls13encryptiontest
  wpackettest
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE testutil ssl)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
########################################
# sshtestlib library
set(ssltestlib_srcs
  ssltestlib.c
  ssltestlib.h
  )
add_library(ssltestlib STATIC ${ssltestlib_srcs})
target_link_libraries(ssltestlib PUBLIC testutil ssl)
set_property(TARGET ssltestlib PROPERTY FOLDER ${folder})
list(APPEND test_srcs ${ssltestlib_srcs})
####################
# tests that depend on ssltestlib
foreach(t
  asynciotest
  dtls_mtu_test
  dtlstest
  fatalerrtest
  gosttest
  recordlentest
  servername_test
  sslapitest
  sslbuffertest
  sslcorrupttest
  tls13ccstest
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE ssltestlib)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
########################################
# tests that depend on testutil and internal headers
foreach(t
  asn1_internal_test
  chacha_internal_test
  ctype_internal_test
  curve448_internal_test
  ec_internal_test
  evp_extra_test
  poly1305_internal_test
  siphash_internal_test
  sm2_internal_test
  sm4_internal_test
  )
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} PRIVATE testutil)
  target_include_directories(${t} PRIVATE ${CMAKE_SOURCE_DIR}/crypto/include)
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${t}.c)
endforeach()
target_include_directories(curve448_internal_test PRIVATE ${CMAKE_SOURCE_DIR}/crypto/ec/curve448)
target_include_directories(ec_internal_test PRIVATE ${CMAKE_SOURCE_DIR}/crypto/ec)
########################################
# tests with multiple sources
set(drbgtest_srcs
  drbgtest.c
  drbgtest.h
  )
set(drbgtest_libs testutil)
##########
set(drbg_cavs_test_srcs
  drbg_cavs_data.c
  drbg_cavs_data.h
  drbg_cavs_test.c
  )
set(drbg_cavs_test_libs testutil)
##########
set(ecdsatest_srcs
  ecdsatest.c
  ecdsatest.h
  )
set(ecdsatest_libs testutil)
##########
set(evp_test_srcs
  evp_test.c
  evp_test.h
  )
set(evp_test_libs testutil)
##########
set(ssl_test_srcs
  handshake_helper.c
  handshake_helper.h
  ssl_test.c
  ssl_test_ctx.c
  ssl_test_ctx.h
  )
set(ssl_test_libs testutil ssl)
##########
set(ssl_test_ctx_test_srcs
  ssl_test_ctx.c
  ssl_test_ctx.h
  ssl_test_ctx_test.c
  ssl_test_ctx_test.conf
  )
set(ssl_test_ctx_test_libs testutil ssl)
##########
foreach(t
  drbgtest
  drbg_cavs_test
  ecdsatest
  evp_test
  ssl_test
  ssl_test_ctx_test
  )
  add_executable(${t} ${${t}_srcs})
  target_link_libraries(${t} PRIVATE ${${t}_libs})
  set_property(TARGET ${t} PROPERTY FOLDER ${folder})
  list(APPEND test_srcs ${${t}_srcs})
endforeach()
########################################
# extra sources (not part of build)
list(APPEND test_srcs
  bntests.pl
  build.info
  CAss.cnf
  CAssdh.cnf
  CAssdsa.cnf
  CAssrsa.cnf
  CAtsa.cnf
  CMakeLists.txt
  cms-examples.pl
  danetest.in
  danetest.pem
  generate_buildtest.pl
  generate_ssl_tests.pl
  P1ss.cnf
  P2ss.cnf
  pkcs7-1.pem
  pkcs7.pem
  pkits-test.pl
  README
  README.external
  README.ssltest.md
  run_tests.pl
  serverinfo2.pem
  serverinfo.pem
  session.pem
  shibboleth.pfx
  smcont.txt
  ssl_test.tmpl
  Sssdsa.cnf
  Sssrsa.cnf
  sysdefault.cnf
  test.cnf
  testcrl.pem
  testdsa.pem
  testdsapub.pem
  testec-p256.pem
  testecpub-p256.pem
  testp7.pem
  testreq2.pem
  testrsa.pem
  testrsapub.pem
  testsid.pem
  testx509.pem
  Uss.cnf
  v3-cert1.pem
  v3-cert2.pem
  )
########################################
# directories (ignore -- add to cmake)
foreach(d
  certs
  ct
  d2i-tests
  ocsp-tests
  ossl_shim
  recipes
  smime-certs
  ssl-tests
  )
  file(GLOB_RECURSE dir RELATIVE ${CMAKE_CURRENT_LIST_DIR} ${d}/*)
  list(APPEND test_srcs ${dir})
endforeach()
########################################
set(TODO # build.info shows instructions
  tls13secretstest.c
  uitest.c
  )
list(APPEND test_srcs ${TODO})
########################################
list(REMOVE_DUPLICATES test_srcs)
compareCmakeFilesys("${test_srcs}")
