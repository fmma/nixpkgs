{ config
, lib
, stdenv
, fetchurl
, zlib
, pkg-config
, mpg123
, libogg
, libvorbis
, portaudio
, libsndfile
, flac
, usePulseAudio ? config.pulseaudio or stdenv.isLinux
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "libopenmpt";
  version = "0.7.3";

  outputs = [ "out" "dev" "bin" ];

  src = fetchurl {
    url = "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${version}+release.autotools.tar.gz";
    hash = "sha256-LPg2m3kWsJJk8/FLn7bO81pum+4DKN7E9J2YIRzP1yI=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
    mpg123
    libogg
    libvorbis
    portaudio
    libsndfile
    flac
  ] ++ lib.optionals usePulseAudio [
    libpulseaudio
  ];

  configureFlags = [
    (lib.strings.withFeature usePulseAudio "pulseaudio")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postFixup = ''
    moveToOutput share/doc $dev
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Cross-platform C++ and C library to decode tracked music files into a raw PCM audio stream";
    mainProgram = "openmpt123";
    longDescription = ''
      libopenmpt is a cross-platform C++ and C library to decode tracked music files (modules) into a raw PCM audio stream.
      openmpt123 is a cross-platform command-line or terminal based module file player.
      libopenmpt is based on the player code of the OpenMPT project.
    '';
    homepage = "https://lib.openmpt.org/libopenmpt/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
  };
}
