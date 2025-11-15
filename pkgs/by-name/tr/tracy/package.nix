{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
  wayland-scanner,

  capstone,
  dbus,
  freetype,
  glfw,
  onetbb,

  withGtkFileSelector ? false,
  gtk3,

  withWayland ? stdenv.hostPlatform.isLinux,
  libglvnd,
  libxkbcommon,
  wayland,
  wayland-protocols,
}: let


  vendorSrcs = import ./vendor.nix {
    inherit fetchFromGitHub;
    inherit (builtins) fetchTarball;
  };

in stdenv.mkDerivation rec {
  pname = if withWayland then "tracy-wayland" else "tracy-glfw";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    hash = "sha256-xxT1xy3S5nh9qMjK+4HnaWJnGGO64a1u7eSwvQBLcPY=";
  };

  patches = lib.optional (
    stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11"
  ) ./dont-use-the-uniformtypeidentifiers-framework.patch;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland-scanner ]
  ++ lib.optionals stdenv.cc.isClang [ stdenv.cc.cc.libllvm ];

  buildInputs = [
    capstone
    freetype
    onetbb
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withGtkFileSelector) [ gtk3 ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && !withGtkFileSelector) [ dbus ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withWayland) [
    libglvnd
    libxkbcommon
    wayland
    wayland-protocols
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && !withWayland)) [
    glfw
  ];

  cmakeFlags = [
    "-DDOWNLOAD_CAPSTONE=off"
    "-DTRACY_STATIC=off"
  ]
  ++ lib.optional (stdenv.hostPlatform.isLinux && withGtkFileSelector) "-DGTK_FILESELECTOR=ON"
  ++ lib.optional (stdenv.hostPlatform.isLinux && !withWayland) "-DLEGACY=on"
  ++ [
    "-DCPM_DOWNLOAD_LOCATION=${src}/cmake/CPM.cmake"
    "-DCPM_PackageProject.cmake_SOURCE=${vendorSrcs.package-project-cmake}"
    "-DCPM_ImGui_SOURCE=/build/deps/imgui"
    "-DFETCHCONTENT_SOURCE_DIR_PPQSORT=${vendorSrcs.ppqsort}"
    #"-DFETCHCONTENT_SOURCE_DIR_CAPSTONE=${vendorSrcs.capstone}"
    "-DFETCHCONTENT_SOURCE_DIR_GLFW=${vendorSrcs.glfw}"
    "-DFETCHCONTENT_SOURCE_DIR_FREETYPE=${vendorSrcs.freetype}"
    "-DFETCHCONTENT_SOURCE_DIR_ZSTD=${vendorSrcs.zstd}"
    "-DFETCHCONTENT_SOURCE_DIR_NFD=${vendorSrcs.nfd}"
    "-DFETCHCONTENT_SOURCE_DIR_JSON=${vendorSrcs.json}"
    "-DFETCHCONTENT_SOURCE_DIR_MD4C=${vendorSrcs.md4c}"
    "-DFETCHCONTENT_SOURCE_DIR_BASE64=${vendorSrcs.base64}"
    "-DFETCHCONTENT_SOURCE_DIR_TIDY=${vendorSrcs.tidy}"
    "-DFETCHCONTENT_SOURCE_DIR_USEARCH=${vendorSrcs.usearch}"
    "-DFETCHCONTENT_SOURCE_DIR_PUGIXML=${vendorSrcs.pugixml}"
    "-DFETCHCONTENT_SOURCE_DIR_LIBCURL=${vendorSrcs.curl}"
    "-DFETCHCONTENT_SOURCE_DIR_WAYLAND_PROTOCOLS=${vendorSrcs.wayland-protocols}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [ ]
    ++ lib.optional stdenv.hostPlatform.isLinux "-ltbb"
    # Workaround for https://github.com/NixOS/nixpkgs/issues/19098
    ++ lib.optional (stdenv.cc.isClang && stdenv.hostPlatform.isDarwin) "-fno-lto"
  );

  dontUseCmakeBuildDir = true;

  preConfigure = ''
    # copy sources to the deps.
    mkdir -p /build/deps
    cp -r ${vendorSrcs.imgui} /build/deps/imgui
    cp -r ${vendorSrcs.zstd} /build/deps/ppqsort
    cp -r ${vendorSrcs.curl} /build/deps/tidy
    
    chmod -R +w /build/deps
  '';

  postConfigure = ''
    cmake -B capture/build -S capture $cmakeFlags
    cmake -B csvexport/build -S csvexport $cmakeFlags
    cmake -B import/build -S import $cmakeFlags
    cmake -B profiler/build -S profiler $cmakeFlags
    cmake -B update/build -S update $cmakeFlags
  '';

  postBuild = ''
    ninja -C capture/build
    ninja -C csvexport/build
    ninja -C import/build
    ninja -C profiler/build
    ninja -C update/build
  '';

  postInstall = ''
    install -D -m 0555 capture/build/tracy-capture -t $out/bin
    install -D -m 0555 csvexport/build/tracy-csvexport $out/bin
    install -D -m 0555 import/build/{tracy-import-chrome,tracy-import-fuchsia} -t $out/bin
    install -D -m 0555 profiler/build/tracy-profiler $out/bin/tracy
    install -D -m 0555 update/build/tracy-update -t $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace extra/desktop/tracy.desktop \
      --replace-fail Exec=/usr/bin/tracy Exec=tracy

    install -D -m 0444 extra/desktop/application-tracy.xml $out/share/mime/packages/application-tracy.xml
    install -D -m 0444 extra/desktop/tracy.desktop $out/share/applications/tracy.desktop
    install -D -m 0444 icon/application-tracy.svg $out/share/icons/hicolor/scalable/apps/application-tracy.svg
    install -D -m 0444 icon/icon.png $out/share/icons/hicolor/256x256/apps/tracy.png
    install -D -m 0444 icon/icon.svg $out/share/icons/hicolor/scalable/apps/tracy.svg
  '';

  meta = with lib; {
    description = "Real time, nanosecond resolution, remote telemetry frame profiler for games and other applications";
    homepage = "https://github.com/wolfpld/tracy";
    license = licenses.bsd3;
    mainProgram = "tracy";
    maintainers = with maintainers; [
      mpickering
      nagisa
    ];
    platforms = platforms.linux ++ lib.optionals (!withWayland) platforms.darwin;
  };
}
