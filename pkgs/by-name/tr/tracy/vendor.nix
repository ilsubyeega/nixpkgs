{ fetchFromGitHub, fetchTarball }:
{
  capstone = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = "6.0.0-Alpha1";
    hash = "sha256-9nFGXpVj+oWIfuOiXXVJodzc8G1hirSiVCMq6dxFV9o=";
  };
  glfw = fetchFromGitHub {
    owner = "glfw";
    repo = "glfw";
    rev = "3.3.8";
    hash = "sha256-4+H0IXjAwbL5mAWfsIVhW0BSJhcWjkQx4j2TrzZ3aIo=";
  };
  freetype = fetchFromGitHub {
    owner = "freetype";
    repo = "freetype";
    rev = "VER-2-13-3";
    hash = "sha256-4l90lDtpgm5xlh2m7ifrqNy373DTRTULRkAzicrM93c=";
  };
  zstd = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v1.5.7";
    hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
  };
  # requires patches
  imgui = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v1.92.1-docking";
    hash = "sha256-9nFGXpVj+oWIfuOiXXVJodzc8G1hirSiVCMq6dxFV9o=";
  };
  nfd = fetchFromGitHub {
    owner = "btzy";
    repo = "nativefiledialog-extended";
    rev = "v1.2.1";
    hash = "sha256-GwT42lMZAAKSJpUJE6MYOpSLKUD5o9nSe9lcsoeXgJY=";
  };
  # requires patches
  ppqsort = fetchFromGitHub {
    owner = "GabTux";
    repo = "PPQSort";
    rev = "v1.0.5";
    hash = "sha256-EMZVI/uyzwX5637/rdZuMZoql5FTrsx0ESJMdLVDmfk=";
  };
  json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v3.12.0";
    hash = "sha256-4+H0IXjAwbL5mAWfsIVhW0BSJhcWjkQx4j2TrzZ3aIo=";
  };
  md4c = fetchFromGitHub {
    owner = "mity";
    repo = "md4c";
    rev = "release-0.5.2";
    hash = "sha256-2/wi7nJugR8X2J9FjXJF1UDnbsozGoO7iR295/KSJng=";
  };
  base64 = fetchFromGitHub {
    owner = "aklomp";
    repo = "base64";
    rev = "v0.5.2";
    hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
  };
  # requires patches
  tidy = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = "5.8.0";
    hash = "sha256-vzVWQodwzi3GvC9IcSQniYBsbkJV20iZanF33A0Gpe0=";
  };
  usearch = fetchFromGitHub {
    owner = "unum-cloud";
    repo = "usearch";
    rev = "v2.19.1";
    hash = "sha256-k+5+omr+VwZA5QtXJxDkv0dKcMgRRr81zDhTwewdwes=";
  };
  pugixml = fetchFromGitHub {
    owner = "zeux";
    repo = "pugixml";
    rev = "v1.15";
    hash = "sha256-t/57lg32KgKPc7qRGQtO/GOwHRqoj78lllSaE/A8Z9Q=";
  };
  curl = fetchFromGitHub {
    owner = "curl";
    repo = "curl";
    rev = "curl-8_14_1";
    hash = "sha256-H6+Q4Y/JIX3k2Ffyf/DeMx6KCCqSz8dvxIA1WcAc6rk=";
  };
  wayland-protocols = fetchTarball {
    url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.37/wayland-protocols-1.37.tar.gz";
    sha256 = "17j9v2i3v16qyc8pp6zq9hjs6nrzgialc5sasnphg9va2vasyb5g";
  };
  package-project-cmake = fetchFromGitHub {
    owner = "TheLartians";
    repo = "PackageProject.cmake";
    rev = "v1.11.1";
    hash = "sha256-E7WZSYDlss5bidbiWL1uX41Oh6JxBRtfhYsFU19kzIw=";
  };
}