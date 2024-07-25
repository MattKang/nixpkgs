{ lib
, stdenv
, fetchurl
, autoreconfHook
, bsd-finger
, perl
, talloc
, linkOpenssl? true, openssl
, withCap ? true, libcap
, withCollectd ? false, collectd
, withJson ? false, json_c
, withLdap ? true, openldap
, withMemcached ? false, libmemcached
, withMysql ? false, libmysqlclient
, withPcap ? true, libpcap
, withRedis ? false, hiredis
, withRest ? false, curl
, withSqlite ? true, sqlite
, withYubikey ? false, libyubikey
}:

assert withRest -> withJson;

stdenv.mkDerivation rec {
  pname = "freeradius";
  version = "3.2.5";

  src = fetchurl {
    url = "https://github.com/FreeRADIUS/freeradius-server/releases/download/release_${lib.replaceStrings [ "." ] [ "_" ] version}/freeradius-server-${version}.tar.gz";
    hash = "sha256-HnX1/Blh2YVNHLPGkhYS++K57bjuUIpafL1p8edgcRU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openssl talloc bsd-finger perl ]
    ++ lib.optional withCap libcap
    ++ lib.optional withCollectd collectd
    ++ lib.optional withJson json_c
    ++ lib.optional withLdap openldap
    ++ lib.optional withMemcached libmemcached
    ++ lib.optional withMysql libmysqlclient
    ++ lib.optional withPcap libpcap
    ++ lib.optional withRedis hiredis
    ++ lib.optional withRest curl
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withYubikey libyubikey;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ lib.optional (!linkOpenssl) "--with-openssl=no";

  postPatch = ''
    substituteInPlace src/main/checkrad.in \
      --replace "/usr/bin/finger" "${bsd-finger}/bin/finger"
  '';

  # By default, freeradius will generate Diffie-Hellman parameters and
  # self-signed TLS certificates during installation. We don't want
  # this, for several reasons:
  # - reproducibility (random generation)
  # - we don't want _anybody_ to use a cert where the private key is on our public binary cache!
  # - we don't want the certs to change each time the package is rebuilt
  # So let's avoid anything getting into our output.
  makeFlags = [ "LOCAL_CERT_FILES=" ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
    "INSTALL_CERT_FILES=" # see comment at makeFlags
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with lib; {
    homepage = "https://freeradius.org/";
    description = "Modular, high performance free RADIUS suite";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sheenobu willibutz ];
    platforms = with platforms; linux;
  };
}
## TODO: include windbind optionally (via samba?)
## TODO: include oracle optionally
## TODO: include ykclient optionally
