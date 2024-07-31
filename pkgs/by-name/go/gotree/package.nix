{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotree";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "elbachir-one";
    repo = "gt";
    rev = "v${version}";
    hash = "sha256-0CI9dQXMlED3VoZwB+QI8kUVrUIx9vGIgNZ7mNsZGgs=";
  };

  vendorHash = null;

  meta = {
    description = "Display a tree of files and directories";
    homepage = "https://github.com/elbachir-one/gt";
    changelog = "https://github.com/elbachir-one/gt/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ schnow265 ];
  };
}
