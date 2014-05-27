set(lib_name crypto)
########################################
# cmake-generate buildinf, opensslconf
# TODO: set BUILDINF_DATE
configure_file(buildinf.h.cmake buildinf.h)
file(READ opensslconf.h.in CONF)
set(CONF "
#define OPENSSL_NO_KRB5
#define OPENSSL_NO_SCTP
#define OPENSSL_NO_EC_NISTP_64_GCC_128
${CONF}"
  )
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/opensslconf.h "${CONF}")
########################################
include_directories(
  ${CMAKE_CURRENT_BINARY_DIR} # buildinf.h
  ${openssl_SOURCE_DIR}
  ${openssl_BINARY_DIR}       # openssl/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}
  asn1  # cmac includes asn1_locl.h
  evp   # cmac includes evp_locl.h
  modes # evp includes modes_lcl.h
  )
########################################
# library sources
####################
# root
set(root_srcs # order from crypto/Makefile
  cryptlib.c
  mem.c
  mem_clr.c
  mem_dbg.c
  cversion.c
  ex_data.c
  cpt_err.c
  ebcdic.c
  uid.c
  o_time.c
  o_str.c
  o_dir.c
  o_fips.c
  o_init.c
  fips_ers.c
  )
set(root_exhdrs
  crypto.h
  opensslv.h
  ${CMAKE_CURRENT_BINARY_DIR}/opensslconf.h
  ebcdic.h
  symhacks.h
  ossl_typ.h
  )
list(APPEND root_srcs
  ${root_exhdrs}
  cryptlib.h
  buildinf.h # cmake-generated (see configure_file above)
  md32_common.h
  o_time.h
  o_str.h
  o_dir.h
  #alphacpuid.pl      # in directory, not in Makefile
  #arm_arch.h         # in directory, not in Makefile
  #armcap.c           # in directory, not in Makefile
  #armv4cpuid.S       # in directory, not in Makefile
  #crypto-lib.com     # in directory, not in Makefile
  #fips_err.h         # in directory, not in Makefile
  #ia64cpuid.S        # in directory, not in Makefile
  #install-crypto.com # in directory, not in Makefile
  #LPdir_nyi.c        # in directory, not in Makefile
  #LPdir_unix.c       # in directory, not in Makefile
  #LPdir_vms.c        # in directory, not in Makefile
  #LPdir_win32.c      # in directory, not in Makefile
  #LPdir_win.c        # in directory, not in Makefile
  #LPdir_wince.c      # in directory, not in Makefile
  Makefile
  #o_dir_test.c       # in directory, not in Makefile
  opensslconf.h.in    # in directory, not in LIBSRC
  #pariscid.pl        # in directory, not in Makefile
  #ppccap.c           # in directory, not in Makefile
  #ppccpuid.pl        # in directory, not in Makefile
  #s390xcap.c         # in directory, not in Makefile
  #s390xcpuid.S       # in directory, not in Makefile
  #sparccpuid.S       # in directory, not in Makefile
  #sparcv9cap.c       # in directory, not in Makefile
  #vms_rms.h          # in directory, not in Makefile
  #x86_64cpuid.pl     # in directory, not in Makefile
  #x86cpuid.pl        # in directory, not in Makefile
  )
source_group("" FILES ${root_srcs})
list(APPEND ${lib_name}_libsrcs ${root_srcs})
list(APPEND ${lib_name}_exhdrs ${root_exhdrs})
####################
# aes
set(aes_srcs # order from crypto/aes/Makefile
  aes/aes_core.c
  aes/aes_misc.c
  aes/aes_ecb.c
  aes/aes_cbc.c
  aes/aes_cfb.c
  aes/aes_ofb.c
  aes/aes_ctr.c
  aes/aes_ige.c
  aes/aes_wrap.c
  )
set(aes_exhdrs
  aes/aes.h
  )
list(APPEND aes_srcs
  ${aes_exhdrs}
  #aes/aes_x86core.c # in directory, not in Makefile
  aes/aes_locl.h
  aes/Makefile
  aes/README
  )
source_group(aes FILES ${aes_srcs})
list(APPEND ${lib_name}_libsrcs ${aes_srcs})
list(APPEND ${lib_name}_exhdrs ${aes_exhdrs})
####################
# asn1
set(asn1_srcs # order from crypto/asn1/Makefile
  asn1/a_object.c
  asn1/a_bitstr.c
  asn1/a_utctm.c
  asn1/a_gentm.c
  asn1/a_time.c
  asn1/a_int.c
  asn1/a_octet.c
  asn1/a_print.c
  asn1/a_type.c
  asn1/a_set.c
  asn1/a_dup.c
  asn1/a_d2i_fp.c
  asn1/a_i2d_fp.c
  asn1/a_enum.c
  asn1/a_utf8.c
  asn1/a_sign.c
  asn1/a_digest.c
  asn1/a_verify.c
  asn1/a_mbstr.c
  asn1/a_strex.c
  asn1/x_algor.c
  asn1/x_val.c
  asn1/x_pubkey.c
  asn1/x_sig.c
  asn1/x_req.c
  asn1/x_attrib.c
  asn1/x_bignum.c
  asn1/x_long.c
  asn1/x_name.c
  asn1/x_x509.c
  asn1/x_x509a.c
  asn1/x_crl.c
  asn1/x_info.c
  asn1/x_spki.c
  asn1/nsseq.c
  asn1/x_nx509.c
  asn1/d2i_pu.c
  asn1/d2i_pr.c
  asn1/i2d_pu.c
  asn1/i2d_pr.c
  asn1/t_req.c
  asn1/t_x509.c
  asn1/t_x509a.c
  asn1/t_crl.c
  asn1/t_pkey.c
  asn1/t_spki.c
  asn1/t_bitst.c
  asn1/tasn_new.c
  asn1/tasn_fre.c
  asn1/tasn_enc.c
  asn1/tasn_dec.c
  asn1/tasn_utl.c
  asn1/tasn_typ.c
  asn1/tasn_prn.c
  asn1/ameth_lib.c
  asn1/f_int.c
  asn1/f_string.c
  asn1/n_pkey.c
  asn1/f_enum.c
  asn1/x_pkey.c
  asn1/a_bool.c
  asn1/x_exten.c
  asn1/bio_asn1.c
  asn1/bio_ndef.c
  asn1/asn_mime.c
  asn1/asn1_gen.c
  asn1/asn1_par.c
  asn1/asn1_lib.c
  asn1/asn1_err.c
  asn1/a_bytes.c
  asn1/a_strnid.c
  asn1/evp_asn1.c
  asn1/asn_pack.c
  asn1/p5_pbe.c
  asn1/p5_pbev2.c
  asn1/p8_pkey.c
  asn1/asn_moid.c
  )
set(asn1_exhdrs
  asn1/asn1.h
  asn1/asn1_mac.h
  asn1/asn1t.h
  )
list(APPEND asn1_srcs
  ${asn1_exhdrs}
  asn1/asn1_locl.h
  #asn1/charmap.h  # in directory, not in Makefile
  #asn1/charmap.pl # in directory, not in Makefile
  asn1/Makefile
  )
source_group(asn1 FILES ${asn1_srcs})
list(APPEND ${lib_name}_libsrcs ${asn1_srcs})
list(APPEND ${lib_name}_exhdrs ${asn1_exhdrs})
####################
# bf
set(bf_srcs # order from crypto/bf/Makefile
  bf/bf_skey.c
  bf/bf_ecb.c
  bf/bf_enc.c
  bf/bf_cfb64.c
  bf/bf_ofb64.c
  )
set(bf_exhdrs
  bf/blowfish.h
  )
list(APPEND bf_srcs
  ${bf_exhdrs}
  bf/bf_locl.h
  bf/bf_pi.h
  #bf/bf_cbc.c  # in directory, not in Makefile
  #bf/bf_opts.c # in directory, not in Makefile
  #bf/bfs.cpp   # in directory, not in Makefile
  #bf/bfspeed.c # in directory, not in Makefile
  #bf/bftest.c  # in directory, not in Makefile
  bf/COPYRIGHT
  bf/INSTALL
  bf/Makefile
  bf/README
  bf/VERSION
  )
source_group(bf FILES ${bf_srcs})
list(APPEND ${lib_name}_libsrcs ${bf_srcs})
list(APPEND ${lib_name}_exhdrs ${bf_exhdrs})
####################
# bio
set(bio_srcs # order from crypto/bio/Makefile
  bio/bio_lib.c
  bio/bio_cb.c
  bio/bio_err.c
  bio/bss_mem.c
  bio/bss_null.c
  bio/bss_fd.c
  bio/bss_file.c
  bio/bss_sock.c
  bio/bss_conn.c
  bio/bf_null.c
  bio/bf_buff.c
  bio/b_print.c
  bio/b_dump.c
  bio/b_sock.c
  bio/bss_acpt.c
  bio/bf_nbio.c
  bio/bss_log.c
  bio/bss_bio.c
  bio/bss_dgram.c
  #bio/bf_lbuf.c # commented-out in Makefile
  )
set(bio_exhdrs
  bio/bio.h
  )
list(APPEND bio_srcs
  ${bio_exhdrs}
  bio/bio_lcl.h
  #bio/bss_rtcp.c # in directory, not in Makefile
  bio/Makefile
  )
source_group(bio FILES ${bio_srcs})
list(APPEND ${lib_name}_libsrcs ${bio_srcs})
list(APPEND ${lib_name}_exhdrs ${bio_exhdrs})
####################
# bn
set(bn_srcs # order from crypto/bn/Makefile
  bn/bn_add.c
  bn/bn_div.c
  bn/bn_exp.c
  bn/bn_lib.c
  bn/bn_ctx.c
  bn/bn_mul.c
  bn/bn_mod.c
  bn/bn_print.c
  bn/bn_rand.c
  bn/bn_shift.c
  bn/bn_word.c
  bn/bn_blind.c
  bn/bn_kron.c
  bn/bn_sqrt.c
  bn/bn_gcd.c
  bn/bn_prime.c
  bn/bn_err.c
  bn/bn_sqr.c
  bn/bn_asm.c
  bn/bn_recp.c
  bn/bn_mont.c
  bn/bn_mpi.c
  bn/bn_exp2.c
  bn/bn_gf2m.c
  bn/bn_nist.c
  bn/bn_depr.c
  bn/bn_const.c
  bn/bn_x931p.c
  )
set(bn_exhdrs
  bn/bn.h
  )
list(APPEND bn_srcs
  ${bn_exhdrs}
  bn/bn_lcl.h
  bn/bn_prime.h
  #bn/bn.mul       # in directory, not in Makefile
  #bn/bn_prime.pl  # in directory, not in LIBSRC
  #bn/bnspeed.c    # in directory, not in Makefile
  #bn/bntest.c     # in directory, not in Makefile
  #bn/divtest.c    # in directory, not in Makefile
  #bn/exp.c        # in directory, not in Makefile
  #bn/expspeed.c   # in directory, not in Makefile
  bn/Makefile
  bn/todo
  #bn/vms-helper.c # in directory, not in Makefile
  )
source_group(bn FILES ${bn_srcs})
list(APPEND ${lib_name}_libsrcs ${bn_srcs})
list(APPEND ${lib_name}_exhdrs ${bn_exhdrs})
####################
# buffer
set(buffer_srcs # order from crypto/buffer/Makefile
  buffer/buffer.c
  buffer/buf_str.c
  buffer/buf_err.c
  )
set(buffer_exhdrs
  buffer/buffer.h
  )
list(APPEND buffer_srcs
  ${buffer_exhdrs}
  buffer/Makefile
  )
source_group(buffer FILES ${buffer_srcs})
list(APPEND ${lib_name}_libsrcs ${buffer_srcs})
list(APPEND ${lib_name}_exhdrs ${buffer_exhdrs})
####################
# camellia
set(camellia_srcs # order from crypto/camellia/Makefile
  camellia/camellia.c
  camellia/cmll_misc.c
  camellia/cmll_ecb.c
  camellia/cmll_cbc.c
  camellia/cmll_ofb.c
  camellia/cmll_cfb.c
  camellia/cmll_ctr.c
  camellia/cmll_utl.c
  )
set(camellia_exhdrs
  camellia/camellia.h
  )
list(APPEND camellia_srcs
  ${camellia_exhdrs}
  camellia/cmll_locl.h
  camellia/Makefile
  )
source_group(camellia FILES ${camellia_srcs})
list(APPEND ${lib_name}_libsrcs ${camellia_srcs})
list(APPEND ${lib_name}_exhdrs ${camellia_exhdrs})
####################
# cast
set(cast_srcs # order from crypto/cast/Makefile
  cast/c_skey.c
  cast/c_ecb.c
  cast/c_enc.c
  cast/c_cfb64.c
  cast/c_ofb64.c
  )
set(cast_exhdrs
  cast/cast.h
  )
list(APPEND cast_srcs
  ${cast_exhdrs}
  cast/cast_lcl.h
  cast/cast_s.h
  #cast/castopts.c # in directory, not in Makefile
  #cast/casts.cpp  # in directory, not in Makefile
  #cast/cast_s.h   # in directory, not in Makefile
  #cast/cast_spd.c # in directory, not in Makefile
  #cast/casttest.c # in directory, not in Makefile
  cast/Makefile
  )
source_group(cast FILES ${cast_srcs})
list(APPEND ${lib_name}_libsrcs ${cast_srcs})
list(APPEND ${lib_name}_exhdrs ${cast_exhdrs})
####################
# cmac
set(cmac_srcs # order from crypto/cmac/Makefile
  cmac/cmac.c
  cmac/cm_ameth.c
  cmac/cm_pmeth.c
  )
set(cmac_exhdrs
  cmac/cmac.h
  )
list(APPEND cmac_srcs
  ${cmac_exhdrs}
  cmac/Makefile
  )
source_group(cmac FILES ${cmac_srcs})
list(APPEND ${lib_name}_libsrcs ${cmac_srcs})
list(APPEND ${lib_name}_exhdrs ${cmac_exhdrs})
####################
# cms
set(cms_srcs # order from crypto/cms/Makefile
  cms/cms_lib.c
  cms/cms_asn1.c
  cms/cms_att.c
  cms/cms_io.c
  cms/cms_smime.c
  cms/cms_err.c
  cms/cms_sd.c
  cms/cms_dd.c
  cms/cms_cd.c
  cms/cms_env.c
  cms/cms_enc.c
  cms/cms_ess.c
  cms/cms_pwri.c
  )
set(cms_exhdrs
  cms/cms.h
  )
list(APPEND cms_srcs
  ${cms_exhdrs}
  cms/cms_lcl.h
  cms/Makefile
  )
source_group(cms FILES ${cms_srcs})
list(APPEND ${lib_name}_libsrcs ${cms_srcs})
list(APPEND ${lib_name}_exhdrs ${cms_exhdrs})
####################
# comp
set(comp_srcs # order from crypto/comp/Makefile
  comp/comp_lib.c
  comp/comp_err.c
  comp/c_rle.c
  comp/c_zlib.c
  )
set(comp_exhdrs
  comp/comp.h
  )
list(APPEND comp_srcs
  ${comp_exhdrs}
  comp/Makefile
  )
source_group(comp FILES ${comp_srcs})
list(APPEND ${lib_name}_libsrcs ${comp_srcs})
list(APPEND ${lib_name}_exhdrs ${comp_exhdrs})
####################
# conf
set(conf_srcs # order from crypto/conf/Makefile
  conf/conf_err.c
  conf/conf_lib.c
  conf/conf_api.c
  conf/conf_def.c
  conf/conf_mod.c
  conf/conf_mall.c
  conf/conf_sap.c
  )
set(conf_exhdrs
  conf/conf.h
  conf/conf_api.h
  )
list(APPEND conf_srcs
  ${conf_exhdrs}
  conf/conf_def.h
  #conf/cnf_save.c # in directory, not in Makefile
  #conf/keysets.pl # in directory, not in Makefile
  conf/Makefile
  conf/README
  #conf/ssleay.cnf # in directory, not in Makefile
  #conf/test.c     # in directory, not in Makefile
  )
source_group(conf FILES ${conf_srcs})
list(APPEND ${lib_name}_libsrcs ${conf_srcs})
list(APPEND ${lib_name}_exhdrs ${conf_exhdrs})
####################
# des
set(des_srcs # order from crypto/des/Makefile
  des/cbc_cksm.c
  des/cbc_enc.c
  des/cfb64enc.c
  des/cfb_enc.c
  des/ecb3_enc.c
  des/ecb_enc.c
  des/enc_read.c
  des/enc_writ.c
  des/fcrypt.c
  des/ofb64enc.c
  des/ofb_enc.c
  des/pcbc_enc.c
  des/qud_cksm.c
  des/rand_key.c
  des/rpc_enc.c
  des/set_key.c
  des/des_enc.c
  des/fcrypt_b.c
  des/xcbc_enc.c
  des/str2key.c
  des/cfb64ede.c
  des/ofb64ede.c
  des/ede_cbcm_enc.c
  des/des_old.c
  des/des_old2.c
  des/read2pwd.c
  )
set(des_exhdrs
  des/des.h
  des/des_old.h
  )
list(APPEND des_srcs
  ${des_exhdrs}
  des/des_locl.h
  des/des_ver.h
  des/rpc_des.h
  des/spr.h
  #des/cbc3_enc.c  # in directory, not in Makefile
  des/COPYRIGHT
  #des/des3s.cpp   # in directory, not in Makefile
  #des/des.c       # in directory, not in Makefile
  des/des-lib.com
  #des/des_opts.c  # in directory, not in Makefile
  des/DES.pm
  des/des.pod
  #des/dess.cpp    # in directory, not in Makefile
  #des/destest.c   # in directory, not in Makefile
  #des/DES.xs      # in directory, not in Makefile
  des/FILES0
  des/Imakefile
  des/INSTALL
  des/KERBEROS
  des/Makefile
  des/makefile.bc
  #des/ncbc_enc.c  # in directory, not in Makefile
  des/options.txt
  des/README
  #des/read_pwd.c  # in directory, not in Makefile
  #des/rpw.c
  #des/speed.c     # in directory, not in Makefile
  des/typemap
  des/VERSION
  )
source_group(des FILES ${des_srcs})
list(APPEND ${lib_name}_libsrcs ${des_srcs})
list(APPEND ${lib_name}_exhdrs ${des_exhdrs})
####################
# dh
set(dh_srcs # order from crypto/dh/Makefile
  dh/dh_asn1.c
  dh/dh_gen.c
  dh/dh_key.c
  dh/dh_lib.c
  dh/dh_check.c
  dh/dh_err.c
  dh/dh_depr.c
  dh/dh_ameth.c
  dh/dh_pmeth.c
  dh/dh_prn.c
  )
set(dh_exhdrs
  dh/dh.h
  )
list(APPEND dh_srcs
  ${dh_exhdrs}
  dh/dh1024.pem
  dh/dh192.pem
  dh/dh2048.pem
  dh/dh4096.pem
  dh/dh512.pem
  #dh/dhtest.c # in directory, not in Makefile
  dh/example
  dh/generate
  dh/Makefile
  #dh/p1024.c  # in directory, not in Makefile
  #dh/p192.c   # in directory, not in Makefile
  #dh/p512.c   # in directory, not in Makefile
  )
source_group(dh FILES ${dh_srcs})
list(APPEND ${lib_name}_libsrcs ${dh_srcs})
list(APPEND ${lib_name}_exhdrs ${dh_exhdrs})
####################
# dsa
set(dsa_srcs # order from crypto/dsa/Makefile
  dsa/dsa_gen.c
  dsa/dsa_key.c
  dsa/dsa_lib.c
  dsa/dsa_asn1.c
  dsa/dsa_vrf.c
  dsa/dsa_sign.c
  dsa/dsa_err.c
  dsa/dsa_ossl.c
  dsa/dsa_depr.c
  dsa/dsa_ameth.c
  dsa/dsa_pmeth.c
  dsa/dsa_prn.c
  )
set(dsa_exhdrs
  dsa/dsa.h
  )
list(APPEND dsa_srcs
  ${dsa_exhdrs}
  dsa/dsa_locl.h
  #dsa/dsagen.c  # in directory, not in Makefile
  #dsa/dsatest.c # in directory, not in Makefile
  dsa/fips186a.txt
  dsa/Makefile
  dsa/README
  )
source_group(dsa FILES ${dsa_srcs})
list(APPEND ${lib_name}_libsrcs ${dsa_srcs})
list(APPEND ${lib_name}_exhdrs ${dsa_exhdrs})
####################
# dso
set(dso_srcs # order from crypto/dso/Makefile
  dso/dso_dl.c
  dso/dso_dlfcn.c
  dso/dso_err.c
  dso/dso_lib.c
  dso/dso_null.c
  dso/dso_openssl.c
  dso/dso_win32.c
  dso/dso_vms.c
  dso/dso_beos.c
  )
set(dso_exhdrs
  dso/dso.h
  )
list(APPEND dso_srcs
  ${dso_exhdrs}
  dso/Makefile
  dso/README
  )
source_group(dso FILES ${dso_srcs})
list(APPEND ${lib_name}_libsrcs ${dso_srcs})
list(APPEND ${lib_name}_exhdrs ${dso_exhdrs})
####################
# ec
set(ec_srcs # order from crypto/ec/Makefile
  ec/ec_lib.c
  ec/ecp_smpl.c
  ec/ecp_mont.c
  ec/ecp_nist.c
  ec/ec_cvt.c
  ec/ec_mult.c
  ec/ec_err.c
  ec/ec_curve.c
  ec/ec_check.c
  ec/ec_print.c
  ec/ec_asn1.c
  ec/ec_key.c
  ec/ec2_smpl.c
  ec/ec2_mult.c
  ec/ec_ameth.c
  ec/ec_pmeth.c
  ec/eck_prn.c
  ec/ecp_nistp224.c
  ec/ecp_nistp256.c
  ec/ecp_nistp521.c
  ec/ecp_nistputil.c
  ec/ecp_oct.c
  ec/ec2_oct.c
  ec/ec_oct.c
  )
set(ec_exhdrs
  ec/ec.h
  )
list(APPEND ec_srcs
  ${ec_exhdrs}
  ec/ec_lcl.h
  #ec/ectest.c # in directory, not in Makefile
  ec/Makefile
  )
source_group(ec FILES ${ec_srcs})
list(APPEND ${lib_name}_libsrcs ${ec_srcs})
list(APPEND ${lib_name}_exhdrs ${ec_exhdrs})
####################
# ecdh
set(ecdh_srcs # order from crypto/ecdh/Makefile
  ecdh/ech_lib.c
  ecdh/ech_ossl.c
  ecdh/ech_key.c
  ecdh/ech_err.c
  )
set(ecdh_exhdrs
  ecdh/ecdh.h
  )
list(APPEND ecdh_srcs
  ${ecdh_exhdrs}
  ecdh/ech_locl.h
  #ecdh/ecdhtest.c # in directory, not in Makefile
  ecdh/Makefile
  )
source_group(ecdh FILES ${ecdh_srcs})
list(APPEND ${lib_name}_libsrcs ${ecdh_srcs})
list(APPEND ${lib_name}_exhdrs ${ecdh_exhdrs})
####################
# ecdsa
set(ecdsa_srcs # order from crypto/ecdsa/Makefile
  ecdsa/ecs_lib.c
  ecdsa/ecs_asn1.c
  ecdsa/ecs_ossl.c
  ecdsa/ecs_sign.c
  ecdsa/ecs_vrf.c
  ecdsa/ecs_err.c
  )
set(ecdsa_exhdrs
  ecdsa/ecdsa.h
  )
list(APPEND ecdsa_srcs
  ${ecdsa_exhdrs}
  ecdsa/ecs_locl.h
  #ecdsa/ecdsatest.c # in directory, not in LIBSRC
  ecdsa/Makefile
  )
source_group(ecdsa FILES ${ecdsa_srcs})
list(APPEND ${lib_name}_libsrcs ${ecdsa_srcs})
list(APPEND ${lib_name}_exhdrs ${ecdsa_exhdrs})
####################
# engine
set(engine_srcs # order from crypto/engine/Makefile
  engine/eng_err.c
  engine/eng_lib.c
  engine/eng_list.c
  engine/eng_init.c
  engine/eng_ctrl.c
  engine/eng_table.c
  engine/eng_pkey.c
  engine/eng_fat.c
  engine/eng_all.c
  engine/tb_rsa.c
  engine/tb_dsa.c
  engine/tb_ecdsa.c
  engine/tb_dh.c
  engine/tb_ecdh.c
  engine/tb_rand.c
  engine/tb_store.c
  engine/tb_cipher.c
  engine/tb_digest.c
  engine/tb_pkmeth.c
  engine/tb_asnmth.c
  engine/eng_openssl.c
  engine/eng_cnf.c
  engine/eng_dyn.c
  engine/eng_cryptodev.c
  engine/eng_rsax.c
  engine/eng_rdrand.c
  )
set(engine_exhdrs
  engine/engine.h
  )
list(APPEND engine_srcs
  ${engine_exhdrs}
  #engine/enginetest.c # in directory, not in LIBSRC
  engine/eng_int.h
  engine/Makefile
  engine/README
  )
source_group(engine FILES ${engine_srcs})
list(APPEND ${lib_name}_libsrcs ${engine_srcs})
list(APPEND ${lib_name}_exhdrs ${engine_exhdrs})
####################
# err
set(err_srcs # order from crypto/err/Makefile
  err/err.c
  err/err_all.c
  err/err_prn.c
  )
set(err_exhdrs
  err/err.h
  )
list(APPEND err_srcs
  ${err_exhdrs}
  err/Makefile
  err/openssl.ec
  )
source_group(err FILES ${err_srcs})
list(APPEND ${lib_name}_libsrcs ${err_srcs})
list(APPEND ${lib_name}_exhdrs ${err_exhdrs})
####################
# evp
set(evp_srcs # order from crypto/evp/Makefile
  evp/encode.c
  evp/digest.c
  evp/evp_enc.c
  evp/evp_key.c
  evp/evp_acnf.c
  evp/evp_cnf.c
  evp/e_des.c
  evp/e_bf.c
  evp/e_idea.c
  evp/e_des3.c
  evp/e_camellia.c
  evp/e_rc4.c
  evp/e_aes.c
  evp/names.c
  evp/e_seed.c
  evp/e_xcbc_d.c
  evp/e_rc2.c
  evp/e_cast.c
  evp/e_rc5.c
  evp/m_null.c
  evp/m_md2.c
  evp/m_md4.c
  evp/m_md5.c
  evp/m_sha.c
  evp/m_sha1.c
  evp/m_wp.c
  evp/m_dss.c
  evp/m_dss1.c
  evp/m_mdc2.c
  evp/m_ripemd.c
  evp/m_ecdsa.c
  evp/p_open.c
  evp/p_seal.c
  evp/p_sign.c
  evp/p_verify.c
  evp/p_lib.c
  evp/p_enc.c
  evp/p_dec.c
  evp/bio_md.c
  evp/bio_b64.c
  evp/bio_enc.c
  evp/evp_err.c
  evp/e_null.c
  evp/c_all.c
  evp/c_allc.c
  evp/c_alld.c
  evp/evp_lib.c
  evp/bio_ok.c
  evp/evp_pkey.c
  evp/evp_pbe.c
  evp/p5_crpt.c
  evp/p5_crpt2.c
  evp/e_old.c
  evp/pmeth_lib.c
  evp/pmeth_fn.c
  evp/pmeth_gn.c
  evp/m_sigver.c
  evp/evp_fips.c
  evp/e_aes_cbc_hmac_sha1.c
  evp/e_rc4_hmac_md5.c
  )
set(evp_exhdrs
  evp/evp.h
  )
list(APPEND evp_srcs
  ${evp_exhdrs}
  evp/evp_locl.h
  #evp/e_dsa.c      # in directory, not in LIBSRC
  #evp/evp_test.c   # in directory, not in LIBSRC
  evp/evptests.txt
  evp/Makefile
  #evp/openbsd_hw.c # in directory, not in LIBSRC
  )
source_group(evp FILES ${evp_srcs})
list(APPEND ${lib_name}_libsrcs ${evp_srcs})
list(APPEND ${lib_name}_exhdrs ${evp_exhdrs})
####################
# hmac
set(hmac_srcs # order from crypto/hmac/Makefile
  hmac/hmac.c
  hmac/hm_ameth.c
  hmac/hm_pmeth.c
  )
set(hmac_exhdrs
  hmac/hmac.h
  )
list(APPEND hmac_srcs
  ${hmac_exhdrs}
  #hmac/hmactest.c # in directory, not in LIBSRC
  hmac/Makefile
  )
source_group(hmac FILES ${hmac_srcs})
list(APPEND ${lib_name}_libsrcs ${hmac_srcs})
list(APPEND ${lib_name}_exhdrs ${hmac_exhdrs})
####################
# idea
set(idea_srcs # order from crypto/idea/Makefile
  idea/i_cbc.c
  idea/i_cfb64.c
  idea/i_ofb64.c
  idea/i_ecb.c
  idea/i_skey.c
  )
set(idea_exhdrs
  idea/idea.h
  )
list(APPEND idea_srcs
  ${idea_exhdrs}
  idea/idea_lcl.h
  #idea/idea_spd.c # in directory, not in LIBSRC
  #idea/ideatest.c # in directory, not in LIBSRC
  idea/Makefile
  idea/version
  )
source_group(idea FILES ${idea_srcs})
list(APPEND ${lib_name}_libsrcs ${idea_srcs})
list(APPEND ${lib_name}_exhdrs ${idea_exhdrs})
####################
# jpake
set(jpake_srcs # order from crypto/jpake/Makefile
  jpake/jpake.c
  jpake/jpake_err.c
  )
set(jpake_exhdrs
  jpake/jpake.h
  )
list(APPEND jpake_srcs
  ${jpake_exhdrs}
  #jpake/jpaketest.c # in directory, not in LIBSRC
  jpake/Makefile
  )
source_group(jpake FILES ${jpake_srcs})
list(APPEND ${lib_name}_libsrcs ${jpake_srcs})
list(APPEND ${lib_name}_exhdrs ${jpake_exhdrs})
####################
# krb5
set(krb5_srcs # order from crypto/krb5/Makefile
  krb5/krb5_asn.c
  )
set(krb5_exhdrs
  krb5/krb5_asn.h
  )
list(APPEND krb5_srcs
  ${krb5_exhdrs}
  krb5/Makefile
  )
source_group(krb5 FILES ${krb5_srcs})
list(APPEND ${lib_name}_libsrcs ${krb5_srcs})
list(APPEND ${lib_name}_exhdrs ${krb5_exhdrs})
####################
# lhash
set(lhash_srcs # order from crypto/lhash/Makefile
  lhash/lhash.c
  lhash/lh_stats.c
  )
set(lhash_exhdrs
  lhash/lhash.h
  )
list(APPEND lhash_srcs
  ${lhash_exhdrs}
  #lhash/lh_test.c # in directory, not in Makefile
  lhash/Makefile
  lhash/num.pl
  )
source_group(lhash FILES ${lhash_srcs})
list(APPEND ${lib_name}_libsrcs ${lhash_srcs})
list(APPEND ${lib_name}_exhdrs ${lhash_exhdrs})
####################
# md2
set(md2_srcs # order from crypto/md2/Makefile
  md2/md2_dgst.c
  md2/md2_one.c
  )
set(md2_exhdrs
  md2/md2.h
  )
list(APPEND md2_srcs
  ${md2_exhdrs}
  md2/Makefile
  #md2/md2.c     # in directory, not in Makefile
  #md2/md2test.c # in directory, not in LIBSRC
  )
source_group(md2 FILES ${md2_srcs})
list(APPEND ${lib_name}_libsrcs ${md2_srcs})
list(APPEND ${lib_name}_exhdrs ${md2_exhdrs})
####################
# md4
set(md4_srcs # order from crypto/md4/Makefile
  md4/md4_dgst.c
  md4/md4_one.c
  )
set(md4_exhdrs
  md4/md4.h
  )
list(APPEND md4_srcs
  ${md4_exhdrs}
  md4/md4_locl.h
  md4/Makefile
  #md4/md4.c     # in directory, not in LIBSRC
  #md4/md4s.cpp  # in directory, not in Makefile
  #md4/md4test.c # in directory, not in LIBSRC
  )
source_group(md4 FILES ${md4_srcs})
list(APPEND ${lib_name}_libsrcs ${md4_srcs})
list(APPEND ${lib_name}_exhdrs ${md4_exhdrs})
####################
# md5
set(md5_srcs # order from crypto/md5/Makefile
  md5/md5_dgst.c
  md5/md5_one.c
  )
set(md5_exhdrs
  md5/md5.h
  )
list(APPEND md5_srcs
  ${md5_exhdrs}
  md5/md5_locl.h
  md5/Makefile
  #md5/md5.c     # in directory, not in Makefile
  #md5/md5s.cpp  # in directory, not in Makefile
  #md5/md5test.c # in directory, not in LIBSRC
  )
source_group(md5 FILES ${md5_srcs})
list(APPEND ${lib_name}_libsrcs ${md5_srcs})
list(APPEND ${lib_name}_exhdrs ${md5_exhdrs})
####################
# mdc2
set(mdc2_srcs # order from crypto/mdc2/Makefile
  mdc2/mdc2dgst.c
  mdc2/mdc2_one.c
  )
set(mdc2_exhdrs
  mdc2/mdc2.h
  )
list(APPEND mdc2_srcs
  ${mdc2_exhdrs}
  mdc2/Makefile
  #mdc2/mdc2test.c # in directory, not in LIBSRC
  )
source_group(mdc2 FILES ${mdc2_srcs})
list(APPEND ${lib_name}_libsrcs ${mdc2_srcs})
list(APPEND ${lib_name}_exhdrs ${mdc2_exhdrs})
####################
# modes
set(modes_srcs # order from crypto/modes/Makefile
  modes/cbc128.c
  modes/ctr128.c
  modes/cts128.c
  modes/cfb128.c
  modes/ofb128.c
  modes/gcm128.c
  modes/ccm128.c
  modes/xts128.c
  )
set(modes_exhdrs
  modes/modes.h
  )
list(APPEND modes_srcs
  ${modes_exhdrs}
  modes/modes_lcl.h
  modes/Makefile
  )
source_group(modes FILES ${modes_srcs})
list(APPEND ${lib_name}_libsrcs ${modes_srcs})
list(APPEND ${lib_name}_exhdrs ${modes_exhdrs})
####################
# objects
set(objects_srcs # order from crypto/objects/Makefile
  objects/o_names.c
  objects/obj_dat.c
  objects/obj_lib.c
  objects/obj_err.c
  objects/obj_xref.c
  )
set(objects_exhdrs
  objects/objects.h
  objects/obj_mac.h
  )
list(APPEND objects_srcs
  ${objects_exhdrs}
  objects/obj_dat.h
  objects/obj_xref.h
  objects/Makefile
  objects/obj_dat.pl
  objects/objects.pl
  objects/objects.README
  objects/objects.txt
  objects/obj_mac.num
  objects/objxref.pl
  objects/obj_xref.txt
  )
source_group(objects FILES ${objects_srcs})
list(APPEND ${lib_name}_libsrcs ${objects_srcs})
list(APPEND ${lib_name}_exhdrs ${objects_exhdrs})
####################
# ocsp
set(ocsp_srcs # order from crypto/ocsp/Makefile
  ocsp/ocsp_asn.c
  ocsp/ocsp_ext.c
  ocsp/ocsp_ht.c
  ocsp/ocsp_lib.c
  ocsp/ocsp_cl.c
  ocsp/ocsp_srv.c
  ocsp/ocsp_prn.c
  ocsp/ocsp_vfy.c
  ocsp/ocsp_err.c
  )
set(ocsp_exhdrs
  ocsp/ocsp.h
  )
list(APPEND ocsp_srcs
  ${ocsp_exhdrs}
  ocsp/Makefile
  )
source_group(ocsp FILES ${ocsp_srcs})
list(APPEND ${lib_name}_libsrcs ${ocsp_srcs})
list(APPEND ${lib_name}_exhdrs ${ocsp_exhdrs})
####################
# pem
set(pem_srcs # order from crypto/pem/Makefile
  pem/pem_sign.c
  pem/pem_seal.c
  pem/pem_info.c
  pem/pem_lib.c
  pem/pem_all.c
  pem/pem_err.c
  pem/pem_x509.c
  pem/pem_xaux.c
  pem/pem_oth.c
  pem/pem_pk8.c
  pem/pem_pkey.c
  pem/pvkfmt.c
  )
set(pem_exhdrs
  pem/pem.h
  pem/pem2.h
  )
list(APPEND pem_srcs
  ${pem_exhdrs}
  pem/Makefile
  pem/message
  pem/pkcs7.lis
  )
source_group(pem FILES ${pem_srcs})
list(APPEND ${lib_name}_libsrcs ${pem_srcs})
list(APPEND ${lib_name}_exhdrs ${pem_exhdrs})
####################
# perlasm
set(perlasm_srcs # no Makefile in directory
  perlasm/cbc.pl
  perlasm/ppc-xlate.pl
  perlasm/readme
  perlasm/x86_64-xlate.pl
  perlasm/x86asm.pl
  perlasm/x86gas.pl
  perlasm/x86masm.pl
  perlasm/x86nasm.pl
  )
source_group(perlasm FILES ${perlasm_srcs})
list(APPEND ${lib_name}_libsrcs ${perlasm_srcs})
####################
# pkcs12
set(pkcs12_srcs # order from crypto/pkcs12/Makefile
  pkcs12/p12_add.c
  pkcs12/p12_asn.c
  pkcs12/p12_attr.c
  pkcs12/p12_crpt.c
  pkcs12/p12_crt.c
  pkcs12/p12_decr.c
  pkcs12/p12_init.c
  pkcs12/p12_key.c
  pkcs12/p12_kiss.c
  pkcs12/p12_mutl.c
  pkcs12/p12_utl.c
  pkcs12/p12_npas.c
  pkcs12/pk12err.c
  pkcs12/p12_p8d.c
  pkcs12/p12_p8e.c
  )
set(pkcs12_exhdrs
  pkcs12/pkcs12.h
  )
list(APPEND pkcs12_srcs
  ${pkcs12_exhdrs}
  pkcs12/Makefile
  )
source_group(pkcs12 FILES ${pkcs12_srcs})
list(APPEND ${lib_name}_libsrcs ${pkcs12_srcs})
list(APPEND ${lib_name}_exhdrs ${pkcs12_exhdrs})
####################
# pkcs7
set(pkcs7_srcs # order from crypto/pkcs7/Makefile
  pkcs7/pk7_asn1.c
  pkcs7/pk7_lib.c
  pkcs7/pkcs7err.c
  pkcs7/pk7_doit.c
  pkcs7/pk7_smime.c
  pkcs7/pk7_attr.c
  pkcs7/pk7_mime.c
  pkcs7/bio_pk7.c
  )
set(pkcs7_exhdrs
  pkcs7/pkcs7.h
  )
list(APPEND pkcs7_srcs
  ${pkcs7_exhdrs}
  #pkcs7/bio_ber.c  # in directory, not in Makefile
  #pkcs7/dec.c      # in directory, not in LIBSRC
  pkcs7/des.pem
  pkcs7/doc
  #pkcs7/enc.c      # in directory, not in LIBSRC
  pkcs7/es1.pem
  #pkcs7/example.c  # in directory, not in LIBSRC
  #pkcs7/example.h  # in directory, not in Makefile
  pkcs7/infokey.pem
  pkcs7/Makefile
  #pkcs7/pk7_dgst.c # in directory, not in Makefile
  #pkcs7/pk7_enc.c  # in directory, not in Makefile
  pkcs7/server.pem
  #pkcs7/sign.c     # in directory, not in LIBSRC
  #pkcs7/verify.c   # in directory, not in LIBSRC
  )
source_group(pkcs7 FILES ${pkcs7_srcs})
list(APPEND ${lib_name}_libsrcs ${pkcs7_srcs})
list(APPEND ${lib_name}_exhdrs ${pkcs7_exhdrs})
####################
# pqueue
set(pqueue_srcs
  pqueue/pqueue.c
  )
set(pqueue_exhdrs
  pqueue/pqueue.h
  )
list(APPEND pqueue_srcs
  ${pqueue_exhdrs}
  pqueue/Makefile
  #pqueue/pq_test.c # in directory, not in Makefile
  )
source_group(pqueue FILES ${pqueue_srcs})
list(APPEND ${lib_name}_libsrcs ${pqueue_srcs})
list(APPEND ${lib_name}_exhdrs ${pqueue_exhdrs})
####################
# rand
set(rand_srcs # order from crypto/rand/Makefile
  rand/md_rand.c
  rand/randfile.c
  rand/rand_lib.c
  rand/rand_err.c
  rand/rand_egd.c
  rand/rand_win.c
  rand/rand_unix.c
  rand/rand_os2.c
  rand/rand_nw.c
  )
set(rand_exhdrs
  rand/rand.h
  )
list(APPEND rand_srcs
  ${rand_exhdrs}
  rand/rand_lcl.h
  rand/Makefile
  #rand/randtest.c # in directory, not in LIBSRC
  #rand/rand_vms.c # in directory, not in Makefile
  )
source_group(rand FILES ${rand_srcs})
list(APPEND ${lib_name}_libsrcs ${rand_srcs})
list(APPEND ${lib_name}_exhdrs ${rand_exhdrs})
####################
# rc2
set(rc2_srcs # order from crypto/rc2/Makefile
  rc2/rc2_ecb.c
  rc2/rc2_skey.c
  rc2/rc2_cbc.c
  rc2/rc2cfb64.c
  rc2/rc2ofb64.c
  )
set(rc2_exhdrs
  rc2/rc2.h
  )
list(APPEND rc2_srcs
  ${rc2_exhdrs}
  rc2/rc2_locl.h
  rc2/Makefile
  #rc2/rc2speed.c # in directory, not in Makefile
  #rc2/rc2test.c  # in directory, not in LIBSRC
  rc2/rrc2.doc
  #rc2/tab.c      # in directory, not in Makefile
  rc2/version
  )
source_group(rc2 FILES ${rc2_srcs})
list(APPEND ${lib_name}_libsrcs ${rc2_srcs})
list(APPEND ${lib_name}_exhdrs ${rc2_exhdrs})
####################
# rc4
set(rc4_srcs # order from crypto/rc4/Makefile
  rc4/rc4_skey.c
  rc4/rc4_enc.c
  rc4/rc4_utl.c
  )
set(rc4_exhdrs
  rc4/rc4.h
  )
list(APPEND rc4_srcs
  ${rc4_exhdrs}
  rc4/rc4_locl.h
  rc4/Makefile
  #rc4/rc4.c      # in directory, not in Makefile
  #rc4/rc4s.cpp   # in directory, not in Makefile
  #rc4/rc4speed.c # in directory, not in Makefile
  #rc4/rc4test.c  # in directory, not in LIBSRC
  rc4/rrc4.doc
  )
source_group(rc4 FILES ${rc4_srcs})
list(APPEND ${lib_name}_libsrcs ${rc4_srcs})
list(APPEND ${lib_name}_exhdrs ${rc4_exhdrs})
####################
# rc5
set(rc5_srcs # order from crypto/rc5/Makefile
  rc5/rc5_skey.c
  rc5/rc5_ecb.c
  rc5/rc5_enc.c
  rc5/rc5cfb64.c
  rc5/rc5ofb64.c
  )
set(rc5_exhdrs
  rc5/rc5.h
  )
list(APPEND rc5_srcs
  ${rc5_exhdrs}
  rc5/rc5_locl.h
  rc5/Makefile
  #rc5/rc5s.cpp   # in directory, not in Makefile
  #rc5/rc5speed.c # in directory, not in Makefile
  #rc5/rc5test.c  # in directory, not in LIBSRC
  )
source_group(rc5 FILES ${rc5_srcs})
list(APPEND ${lib_name}_libsrcs ${rc5_srcs})
list(APPEND ${lib_name}_exhdrs ${rc5_exhdrs})
####################
# ripemd
set(ripemd_srcs # order from crypto/ripemd/Makefile
  ripemd/rmd_dgst.c
  ripemd/rmd_one.c
  )
set(ripemd_exhdrs
  ripemd/ripemd.h
  )
list(APPEND ripemd_srcs
  ${ripemd_exhdrs}
  ripemd/rmd_locl.h
  ripemd/rmdconst.h
  ripemd/Makefile
  ripemd/README
  #ripemd/rmd160.c  # in directory, not in Makefile
  #ripemd/rmdtest.c # in directory, not in LIBSRC
  )
source_group(ripemd FILES ${ripemd_srcs})
list(APPEND ${lib_name}_libsrcs ${ripemd_srcs})
list(APPEND ${lib_name}_exhdrs ${ripemd_exhdrs})
####################
# rsa
set(rsa_srcs # order from crypto/rsa/Makefile
  rsa/rsa_eay.c
  rsa/rsa_gen.c
  rsa/rsa_lib.c
  rsa/rsa_sign.c
  rsa/rsa_saos.c
  rsa/rsa_err.c
  rsa/rsa_pk1.c
  rsa/rsa_ssl.c
  rsa/rsa_none.c
  rsa/rsa_oaep.c
  rsa/rsa_chk.c
  rsa/rsa_null.c
  rsa/rsa_pss.c
  rsa/rsa_x931.c
  rsa/rsa_asn1.c
  rsa/rsa_depr.c
  rsa/rsa_ameth.c
  rsa/rsa_prn.c
  rsa/rsa_pmeth.c
  rsa/rsa_crpt.c
  )
set(rsa_exhdrs
  rsa/rsa.h
  )
list(APPEND rsa_srcs
  ${rsa_exhdrs}
  rsa/rsa_locl.h
  rsa/Makefile
  #rsa/rsa_test.c # in directory, not in LIBSRC
  )
source_group(rsa FILES ${rsa_srcs})
list(APPEND ${lib_name}_libsrcs ${rsa_srcs})
list(APPEND ${lib_name}_exhdrs ${rsa_exhdrs})
####################
# seed
set(seed_srcs # order from crypto/seed/Makefile
  seed/seed.c
  seed/seed_ecb.c
  seed/seed_cbc.c
  seed/seed_cfb.c
  seed/seed_ofb.c
  )
set(seed_exhdrs
  seed/seed.h
  )
list(APPEND seed_srcs
  ${seed_exhdrs}
  seed/seed_locl.h
  seed/Makefile
  )
source_group(seed FILES ${seed_srcs})
list(APPEND ${lib_name}_libsrcs ${seed_srcs})
list(APPEND ${lib_name}_exhdrs ${seed_exhdrs})
####################
# sha
set(sha_srcs # order from crypto/sha/Makefile
  sha/sha_dgst.c
  sha/sha1dgst.c
  sha/sha_one.c
  sha/sha1_one.c
  sha/sha256.c
  sha/sha512.c
  )
set(sha_exhdrs
  sha/sha.h
  )
list(APPEND sha_srcs
  ${sha_exhdrs}
  sha/sha_locl.h
  sha/Makefile
  #sha/sha1.c     # in directory, not in Makefile
  #sha/sha1test.c # in directory, not in LIBSRC
  #sha/sha256t.c  # in directory, not in LIBSRC
  #sha/sha512t.c  # in directory, not in LIBSRC
  #sha/sha.c      # in directory, not in Makefile
  #sha/shatest.c  # in directory, not in LIBSRC
  )
source_group(sha FILES ${sha_srcs})
list(APPEND ${lib_name}_libsrcs ${sha_srcs})
list(APPEND ${lib_name}_exhdrs ${sha_exhdrs})
####################
# srp
set(srp_srcs
  srp/srp_lib.c
  srp/srp_vfy.c
  )
set(srp_exhdrs
  srp/srp.h
  )
list(APPEND srp_srcs
  ${srp_exhdrs}
  srp/srp_grps.h
  srp/srp_lcl.h
  srp/Makefile
  #srp/srptest.c # in directory, not in LIBSRC
  )
source_group(srp FILES ${srp_srcs})
list(APPEND ${lib_name}_libsrcs ${srp_srcs})
list(APPEND ${lib_name}_exhdrs ${srp_exhdrs})
####################
# stack
set(stack_srcs
  stack/stack.c
  )
set(stack_exhdrs
  stack/stack.h
  stack/safestack.h
  )
list(APPEND stack_srcs
  ${stack_exhdrs}
  stack/Makefile
  )
source_group(stack FILES ${stack_srcs})
list(APPEND ${lib_name}_libsrcs ${stack_srcs})
list(APPEND ${lib_name}_exhdrs ${stack_exhdrs})
####################
# store
set(store_srcs # order from crypto/store/Makefile
  store/str_err.c
  store/str_lib.c
  store/str_meth.c
  store/str_mem.c
  )
set(store_exhdrs
  store/store.h
  )
list(APPEND store_srcs
  ${store_exhdrs}
  store/str_locl.h
  store/Makefile
  store/README
  )
source_group(store FILES ${store_srcs})
list(APPEND ${lib_name}_libsrcs ${store_srcs})
list(APPEND ${lib_name}_exhdrs ${store_exhdrs})
####################
# threads
set(threads_srcs # no Makefile in directory
  #threads/mttest.c
  threads/netware.bat
  threads/profile.sh
  threads/ptest.bat
  threads/pthread2.sh
  threads/pthread.sh
  threads/pthreads-vms.com
  threads/purify.sh
  threads/README
  threads/solaris.sh
  #threads/th-lock.c
  threads/win32.bat
  )
source_group(threads FILES ${threads_srcs})
list(APPEND ${lib_name}_libsrcs ${threads_srcs})
####################
# ts
set(ts_srcs # order from crypto/ts/Makefile
  ts/ts_err.c
  ts/ts_req_utils.c
  ts/ts_req_print.c
  ts/ts_rsp_utils.c
  ts/ts_rsp_print.c
  ts/ts_rsp_sign.c
  ts/ts_rsp_verify.c
  ts/ts_verify_ctx.c
  ts/ts_lib.c
  ts/ts_conf.c
  ts/ts_asn1.c
  )
set(ts_exhdrs
  ts/ts.h
  )
list(APPEND ts_srcs
  ${ts_exhdrs}
  ts/Makefile
  )
source_group(ts FILES ${ts_srcs})
list(APPEND ${lib_name}_libsrcs ${ts_srcs})
list(APPEND ${lib_name}_exhdrs ${ts_exhdrs})
####################
# txt_db
set(txt_db_srcs
  txt_db/txt_db.c
  )
set(txt_db_exhdrs
  txt_db/txt_db.h
  )
list(APPEND txt_db_srcs
  ${txt_db_exhdrs}
  txt_db/Makefile
  )
source_group(txt_db FILES ${txt_db_srcs})
list(APPEND ${lib_name}_libsrcs ${txt_db_srcs})
list(APPEND ${lib_name}_exhdrs ${txt_db_exhdrs})
####################
# ui
set(ui_srcs # order from crypto/ui/Makefile
  ui/ui_err.c
  ui/ui_lib.c
  ui/ui_openssl.c
  ui/ui_util.c
  ui/ui_compat.c
  )
set(ui_exhdrs
  ui/ui.h
  ui/ui_compat.h
  )
list(APPEND ui_srcs
  ${ui_exhdrs}
  ui/ui_locl.h
  ui/Makefile
  )
source_group(ui FILES ${ui_srcs})
list(APPEND ${lib_name}_libsrcs ${ui_srcs})
list(APPEND ${lib_name}_exhdrs ${ui_exhdrs})
####################
# whrlpool
set(whrlpool_srcs # order from crypto/whrlpool/Makefile
  whrlpool/wp_dgst.c
  whrlpool/wp_block.c
  )
set(whrlpool_exhdrs
  whrlpool/whrlpool.h
  )
list(APPEND whrlpool_srcs
  ${whrlpool_exhdrs}
  whrlpool/wp_locl.h
  whrlpool/Makefile
  #whrlpool/wp_test.c # in directory, not in LIBSRC
  )
source_group(whrlpool FILES ${whrlpool_srcs})
list(APPEND ${lib_name}_libsrcs ${whrlpool_srcs})
list(APPEND ${lib_name}_exhdrs ${whrlpool_exhdrs})
####################
# x509
set(x509_srcs # order from crypto/x509/Makefile
  x509/x509_def.c
  x509/x509_d2.c
  x509/x509_r2x.c
  x509/x509_cmp.c
  x509/x509_obj.c
  x509/x509_req.c
  x509/x509spki.c
  x509/x509_vfy.c
  x509/x509_set.c
  x509/x509cset.c
  x509/x509rset.c
  x509/x509_err.c
  x509/x509name.c
  x509/x509_v3.c
  x509/x509_ext.c
  x509/x509_att.c
  x509/x509type.c
  x509/x509_lu.c
  x509/x_all.c
  x509/x509_txt.c
  x509/x509_trs.c
  x509/by_file.c
  x509/by_dir.c
  x509/x509_vpm.c
  )
set(x509_exhdrs
  x509/x509.h
  x509/x509_vfy.h
  )
list(APPEND x509_srcs
  ${x509_exhdrs}
  x509/Makefile
  )
source_group(x509 FILES ${x509_srcs})
list(APPEND ${lib_name}_libsrcs ${x509_srcs})
list(APPEND ${lib_name}_exhdrs ${x509_exhdrs})
####################
# x509v3
set(x509v3_srcs # order from crypto/x509v3/Makefile
  x509v3/v3_bcons.c
  x509v3/v3_bitst.c
  x509v3/v3_conf.c
  x509v3/v3_extku.c
  x509v3/v3_ia5.c
  x509v3/v3_lib.c
  x509v3/v3_prn.c
  x509v3/v3_utl.c
  x509v3/v3err.c
  x509v3/v3_genn.c
  x509v3/v3_alt.c
  x509v3/v3_skey.c
  x509v3/v3_akey.c
  x509v3/v3_pku.c
  x509v3/v3_int.c
  x509v3/v3_enum.c
  x509v3/v3_sxnet.c
  x509v3/v3_cpols.c
  x509v3/v3_crld.c
  x509v3/v3_purp.c
  x509v3/v3_info.c
  x509v3/v3_ocsp.c
  x509v3/v3_akeya.c
  x509v3/v3_pmaps.c
  x509v3/v3_pcons.c
  x509v3/v3_ncons.c
  x509v3/v3_pcia.c
  x509v3/v3_pci.c
  x509v3/pcy_cache.c
  x509v3/pcy_node.c
  x509v3/pcy_data.c
  x509v3/pcy_map.c
  x509v3/pcy_tree.c
  x509v3/pcy_lib.c
  x509v3/v3_asid.c
  x509v3/v3_addr.c
  )
set(x509v3_exhdrs
  x509v3/x509v3.h
  )
list(APPEND x509v3_srcs
  ${x509v3_exhdrs}
  x509v3/pcy_int.h
  x509v3/ext_dat.h
  x509v3/Makefile
  #x509v3/tabtest.c # in directory, not in Makefile
  #x509v3/v3conf.c  # in directory, not in Makefile
  #x509v3/v3prin.c  # in directory, not in Makefile
  )
source_group(x509v3 FILES ${x509v3_srcs})
list(APPEND ${lib_name}_libsrcs ${x509v3_srcs})
list(APPEND ${lib_name}_exhdrs ${x509v3_exhdrs})
########################################
# headers to openssl (for build)
add_custom_command(OUTPUT ${lib_name}_hdrs_cmd
  COMMAND ${CMAKE_COMMAND} -Dsrc:STRING="${${lib_name}_exhdrs}"
    -DsrcDir:PATH=${CMAKE_CURRENT_SOURCE_DIR}
    -Ddst:PATH=${CMAKE_BINARY_DIR}/openssl -P ${openssl_SOURCE_DIR}/cpln.cmake
  )
add_custom_target(${lib_name}_hdrs
  DEPENDS ossl_hdrs ${lib_name}_hdrs_cmd
  SOURCES ${openssl_SOURCE_DIR}/cpln.cmake
  )
set_property(TARGET ${lib_name}_hdrs PROPERTY FOLDER openssl_h)
########################################
# library
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
add_dependencies(${lib_name} ${lib_name}_hdrs)
########################################
# install
install(TARGETS ${lib_name} EXPORT ${PROJECT_NAME}-targets
  RUNTIME DESTINATION bin${NUMBITS}
  LIBRARY DESTINATION lib${NUMBITS}
  ARCHIVE DESTINATION lib${NUMBITS}
  )
install(FILES ${${lib_name}_exhdrs} DESTINATION include/openssl)
