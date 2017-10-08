#!/bin/bash
declare GPG_KEYRING="trustedkeys.gpg"
# more info about these PGP keys:
#   - http://www.cipherdyne.org/contact.html
#   - http://www.nongnu.org/tiger/key.html & http://savannah.nongnu.org/users/jfs
#   - http://www.atagar.com/pgp.php
#   - https://kismetwireless.net/download.shtml#gpg
#   - https://tails.boum.org/download/index.en.html#verify
#   - TODO: http://www.snort.org/snort-downloads#pgp
#   - https://www.kali.org/downloads/
#   - https://cisofy.com/documentation/lynis/#no-installation
#   - https://wiki.qubes-os.org/wiki/VerifyingSignatures
declare -ra PGP_URLS=(
  "https://www.cipherdyne.org/signing_key"
  "https://savannah.nongnu.org/people/viewgpg.php?user_id=7475"
  "https://www.atagar.com/resources/damianJohnson.asc"
  "https://www.kismetwireless.net/dragorn.gpg"
  "https://tails.boum.org/tails-signing.key"
  "https://grsecurity.net/spender-gpg-key.asc"
  "https://sourceforge.net/projects/apcupsd/files/apcupsd%20Public%20Key/Current%20Public%20Key/apcupsd.pub/download"
  "https://www.kali.org/archive-key.asc"
  "https://cisofy.com/files/cisofy-software.pub"
  "https://keys.qubes-os.org/keys/qubes-release-2-signing-key.asc"
  "https://bitcoin.org/laanwj-releases.asc"
  "https://keybase.io/docs/server_security/code_signing_key.asc"
)
# other PGP keys:
#   Slackware related:
#
#   - 0x6A4463C040102233 - http://www.slackbuilds.org/faq/#asc
#   - 0x0368EF579C7BA3B6 - http://slackbuilds.org/GPG-KEY
#
#   metasploit keys:

#   - 2007B954 - metasploit (18.6.2013)
#
#   Tor project:
#   - 28988BF5 - Roger from torproject
#                https://www.torproject.org/docs/verifying-signatures.html.en
#   - 19F78451 - -- || --
#
#   - 0x72B97DB1295029F1 - http://www.openwall.com/signatures/ (295029F1)
#   - 0x21194EBB165733EA - http://www.wangafu.net/~nickm/ 8D29319A - Nick Mathewson (libevent)
#   - 6980F8B0 - Breno Silva (ModSecurity)
#     0xE6DFB08CE8B11277 - Felipe "Zimmerle" Costa
#   - D679F6CF - Karl Berry <karl@freefriends.org> (gawk)
#   - BF2EA563 - Fabian Keil, lead developer of privoxy
#   - 63FEE659 - Erinn Clark (Tor Browser Bundles)
#                https://www.torproject.org/docs/signing-keys.html.en
#   - 0x4E2C6E8793298290 - Tor Browser Developers (signing key) <torbrowser@torproject.org>
#   - 6294BE9B - http://www.debian.org/CD/verify
#   - 9624FCD2 - Ryan Barnett (OWASP Core Rule Set Project Leader) <rbarnett@trustwave.com>
#                https://www.owasp.org/index.php/Category:OWASP_ModSecurity_Core_Rule_Set_Project#Download
#   - 4245D46A - Bradley Spengler (spender) (grsecurity)
#                https://grsecurity.net/contact.php
#   - 6092693E - https://www.kernel.org/signature.html
#     79BE3E4300411886 Linus Torvalds
#   - DDC6C0AD - https://www.torproject.org/torbutton/
#   - 73647CFF - Nico Golde (Debian Advisories)
#   - 86FF9C48 - Damien Miller (Personal Key) <djm@mindrot.org> (OpenSSH)
#     0xD3E5F56B6D920D30
#   - 77F95F95 - Werner Koch <wk@gnupg.org> (gnupg-announce@gnupg.org)
#   - 0x249B39D24F25E3B6 - Werner Koch (dist sig)
#   - 0x2071B08A33BD3F06 - NIIBE Yutaka (GnuPG Release Key)
#   - 54FC8640 - Debian security advisory
#   - 14595A1A - Renaud Deraison (Nessus)
#   - 15A0A4BC - Mozilla Software Releases <releases@mozilla.org>
#   - 5E9905DB - Mozilla Software Releases <releases@mozilla.org>
#   - 5F2E4935 - https://support.mayfirst.org/wiki/faq/security/mfpl-certificate-authority Jamie McClelland <jamie@mayfirst.org>
#     D21739E9   dkg
#   - 0x0B7F8B60E3EDFAE3 - https://www.sks-keyservers.net/overview-of-pools.php
#   - 0x2E8DD26C53F1197DDF403E6118E667F1EB8AF314 - https://web.monkeysphere.info/archive-key/
#   - F0D6B1E0 - http://www.truecrypt.org/docs/digital-signatures
#   - F295C759 - OpenSSL
#   - FA40E9E2 - steve@openssl.org
#   - 0xD9C4D26D0E604491 - matt@openssl.org
#   - 0x715ED6A07E7B8AC9 - key that can be used to verify SPI's CA cert - http://www.spi-inc.org/ca/
#   - 0xDED64EBB2BA87C5C - OTR Dev Team <otr@cypherpunks.ca>
#   - 0x7CBD620BEC70B1B8 - https://ssl.intevation.de/ - used to sign Gpg4win
#   - 0x41259773973A612A - https://bitbucket.org/skskeyserver/sks-keyserver/src/tip/README.md
#   - 0x40B8EA2364221D53 - Sourcefire VRT GPG Key (at least ClamAV)
#   - 0xBB5869F064EA74AB - Chet Ramey / GNU / Bash
#   - 0x17167CB4EE3A8EED - https://www.apple.com/support/security/pgp/
#     0x83A3EF8C346CB446
#   - 0xB88B2FD43DBDC284 - http://software.opensuse.org/132/en
#   - 0x24C6A8A7F4A80EB5 - https://www.centos.org/keys/#centos-7-signing-key
#   - 0x409B6B1796C275462A1703113804BB82D39DC0E3 - RVM https://rvm.io/rvm/security
#   - 0x4623E8F745953F23 - http://deb.mempo.org/
#   - 0x00CCB587DDBEF0E1 - The Irssi project <staff@irssi.org>
#   - 1E453B2CE87BEE2F7DFE99661E34A1828E207901 - LEAP (https://bitmask.net/en/install/signature-verification)
#   - 0xC29D97ED198D22A3 - https://openvpn.net/index.php/open-source/documentation/sig.html
#   - 0x12F5F7B42F2B01E7 - OpenVPN 2.4.3+
#   - 0x1AF51CE72993D5F9 - Mixmaster 3.x Code Release Signing Key
#   - 0x6887935AB297B391 - sukhbir@torproject.org (Tor messenger)
#   - 0xADEF768480316BDA - Kevin McCarthy's key (mutt)
#   - 0xD94AA3F0EFE21092 - Ubuntu https://help.ubuntu.com/community/VerifyIsoHowto
#   - 0x46181433FBB75451 - Ubuntu
#   - 0xD1AFBCE00F6C91D2 - DNSSEC Manager <dnssec@iana.org>
#   - 0xBEA8F6E25378AAF8 - OpenWrt signing key
#   - 0xF6947DAB68E7B931 - Hannes von Haugwitz's key (Aide)
#   - 0x9DFE2648B43434E4 - PuTTY Releases
#   - 0x3C17DA8B8A16544F - Hashcat signing key
#   - 0xD9B0577BD93E98FC - Milan Broz <gmazyland@gmail.com> (cryptsetup)
#   - 0x04D041E8171901CC - julien.voisin @ dustri.org (https://mat.boum.org/)
#   - 0xABCA792D54BF70F2 - Immunity Debugger (Immunity Inc.)
#   - 0xFE22C6FD83135D45 - Felix Geyer (KeePassX)
#   - 0392335A78083894A4301C43236E8A58C6DB4512 - Max Kellermann (Music Player Daemon)
#   - 0x01AF9F036B9355D0 - nmap https://nmap.org/book/install.html#inst-integrity
declare -ra PGP_KEYS=(
  # slackware
  "0x6A4463C040102233"
  "0x0368EF579C7BA3B6"

  # metasploit
  "0xCDFB5FA52007B954"

  # tor
  "0xEB5A896A28988BF5"
  "0xC218525819F78451"

  # openwall
  "0x72B97DB1295029F1"

  "0x21194EBB165733EA"
  "0x8050C35A6980F8B0"
  "0xE6DFB08CE8B11277"
  "0x9DEB46C0D679F6CF"
  "0x48C5521FBF2EA563"
  "0x416F061063FEE659"
  "0x4E2C6E8793298290"
  "0xDA87E80D6294BE9B"
  "0xC976607D9624FCD2"
  #"4245D46A"
  "0x38DBBDC86092693E"
  "0x79BE3E4300411886"
  "0x1B0CA30CDDC6C0AD"
  "0x1D87E54973647CFF"
  "0xCE8ECB0386FF9C48"
  "0xD3E5F56B6D920D30"
  "0x4F0540D577F95F95"
  "0x249B39D24F25E3B6"
  "0x2071B08A33BD3F06"
  "0x1BF83C5E54FC8640"
  "0xF091044D14595A1A"
  "0x057CC3EB15A0A4BC"
  "5E9905DB"
  "0xBB0B7EE15F2E4935"
  "0xCCD2ED94D21739E9"
  "0x0B7F8B60E3EDFAE3"
  "0x2E8DD26C53F1197DDF403E6118E667F1EB8AF314"
  "0xE3BA73CAF0D6B1E0"
  "0xA2D29B7BF295C759"
  "0xD3577507FA40E9E2"
  "0xD9C4D26D0E604491"
  "0x715ED6A07E7B8AC9"
  "0xDED64EBB2BA87C5C"
  "0x7CBD620BEC70B1B8"
  "0x41259773973A612A"
  "0x40B8EA2364221D53"
  "0xBB5869F064EA74AB"
  "0x17167CB4EE3A8EED"
  "0x83A3EF8C346CB446"
  "0xB88B2FD43DBDC284"
  "0x24C6A8A7F4A80EB5"
  "0x409B6B1796C275462A1703113804BB82D39DC0E3"
  "0x4623E8F745953F23"
  "0x00CCB587DDBEF0E1"
  "0x1E453B2CE87BEE2F7DFE99661E34A1828E207901"
  "0xC29D97ED198D22A3"
  "0x12F5F7B42F2B01E7"
  "0x1AF51CE72993D5F9"
  "0x6887935AB297B391"
  "0xADEF768480316BDA"
  "0xD94AA3F0EFE21092"
  "0x46181433FBB75451"
  "0xD1AFBCE00F6C91D2"
  "0xBEA8F6E25378AAF8"
  "0xF6947DAB68E7B931"
  "0x9DFE2648B43434E4"
  "0x3C17DA8B8A16544F"
  "0xD9B0577BD93E98FC"
  "0x04D041E8171901CC"
  "0xABCA792D54BF70F2"
  "0x164C70512F7929476764AB56FE22C6FD83135D45"
  "0x0392335A78083894A4301C43236E8A58C6DB4512"
  "0x01AF9F036B9355D0"
)
function import_pgp_keys() {
  local URL
  local PGP_KEY
  local SKS_HASH
  local schema

  cat 0<<-EOF
	
	importing PGP keys
	------------------
EOF
  # keys with URL
  echo -n "from URLs (${#PGP_URLS[*]} keys)"
  for URL in ${PGP_URLS[*]}
  do
    schema="${URL%%:*}"
    if [ "${schema}" != "https" ]
    then
      echo "[-] WARNING: refusing to download PGP key as schema!=https" 1>&2
      continue
    fi
    # after importing these keys, we can verify slackware packages with gpgv
    /usr/bin/wget --append-output="${logdir}/wget-log.txt" --tries=5 "${URL}" -nv --output-document=- | gpg --logger-fd 1 --keyring "${GPG_KEYRING}" --no-default-keyring --import - &>>"${logdir}/pgp_keys.txt"
    echo -n '.'
  done
  echo -n $'\n'

  # if GnuPG is new enough, it uses dirmngr and all the SKS CA stuff is unnecessary.
  if gpg --version | head -1 | grep -q '^gpg (GnuPG) 2\.'
  then
    # keys with key ID
    echo -n "from keyserver (${#PGP_KEYS[*]} keys)"
    for PGP_KEY in ${PGP_KEYS[*]}
    do
      /usr/bin/gpg \
        --logger-fd 1 \
        --keyring "${GPG_KEYRING}" --no-default-keyring \
        --recv-keys "${PGP_KEY}" &>>"${logdir}/pgp_keys.txt"
      echo -n '.'
    done
    echo -n $'\n'
  else
    # some CAs that are used with HKPS
    #
    # https://en.wikipedia.org/wiki/Key_server_%28cryptographic%29#Keyserver_examples
    # https://we.riseup.net/riseuplabs+paow/openpgp-best-practices#consider-making-your-default-keyserver-use-a-keyse
    if [ "${USER}" = "root" ] && [ ! -d /usr/share/ca-certificates/local ]
    then
      # NOTE: update-ca-certificates will add /usr/local/share/ca-certificates/*.crt to globally trusted CAs... which of course, is not good!
      #mkdir -pvm 755 /usr/local/share/ca-certificates
      mkdir -pvm 755 /usr/share/ca-certificates/local
    fi
    if [ "${USER}" = "root" ] && [ ! -f "${CADIR}/${SKS_CA}" ]
    then
      # https://www.sks-keyservers.net/verify_tls.php
      echo "[+] dropping SKS certificate to ${CADIR}"
      cat "${CWD}/certificates/${SKS_CA}" 1>"${CADIR}/${SKS_CA}"
      chmod -c 644 "${CADIR}/${SKS_CA}" | tee -a "${logdir}/file_perms.txt"
    # for regular users
    elif [ "${USER}" != "root" ] && [ ! -f "${CADIR}/${SKS_CA}" ]
    then
      echo "[-] error: sks-keyservers CA not available. can not continue! try to run this as root to install the CA." 1>&2
      return 1
    fi
    # get the CRL
    SKS_HASH=$( openssl x509 -in ${CADIR}/${SKS_CA} -noout -hash )
    if [ -n "${SKS_HASH}" ] && [ "${USER}" = "root" ]
    then
      echo "[+] fetching SKS CRL to ${CADIR}/${SKS_HASH}.r0"
      wget --append-output="${logdir}/wget-log.txt" -nv --ca-certificate=/usr/share/ca-certificates/mozilla/Thawte_Premium_Server_CA.crt https://sks-keyservers.net/ca/crl.pem -O "${CADIR}/${SKS_HASH}.r0"
      chmod -c 644 "${CADIR}/${SKS_HASH}.r0" | tee -a "${logdir}/file_perms.txt"
    fi
    echo "[+] verifying SKS CA"
    sha512sum -c 0<<<"d0a056251372367230782e050612834a2efa2fdd80eeba08e490a770691e4ddd52a744fd3f3882ca4188f625c3554633381ac90de8ea142519166277cadaf7b0  ${CADIR}/${SKS_CA}" 1>/dev/null
    if [ ${?} -ne 0 ]
    then
      echo "[-] error: sks-keyservers CA's SHA-512 fingerprint does not match!" 1>&2
      return 1
    fi
    # if the distro is Debian, check if gnupg-curl is installed
    if [ "${DISTRO}" = "debian" -o "${DISTRO}" = "raspbian" ]
    then
      /usr/bin/dpkg -s gnupg-curl &>/dev/null || echo "[-] WARNING: package \`gnupg-curl' not installed!" 1>&2
    fi
    # keys with key ID
    echo -n "from keyserver (${#PGP_KEYS[*]} keys)"
    for PGP_KEY in ${PGP_KEYS[*]}
    do
      /usr/bin/gpg \
        --logger-fd 1 \
        --keyserver "hkps://hkps.pool.sks-keyservers.net" \
        --keyserver-options ca-cert-file=${CADIR}/${SKS_CA} \
        --keyring "${GPG_KEYRING}" --no-default-keyring \
        --recv-keys "${PGP_KEY}" &>>"${logdir}/pgp_keys.txt"
      echo -n '.'
    done
    echo -n $'\n'
  fi
  return 0
} # import_pgp_keys()
