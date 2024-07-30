{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mdformat,
  poetry-core,
  pytest-cov,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mdformat-wikilink";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tmr232";
    repo = "mdformat-wikilink";
    rev = "v${version}";
    hash = "sha256-KOPh9iZfb3GCvslQeYBgqNaOyqtWi2llkaiWE7nmcJo=";
  };

  nativeBuildInputs = [
    poetry-core
    pytest-cov
  ];

  propagatedBuildInputs = [ mdformat ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_wikilink" ];

  meta = with lib; {
    description = "An mdformat plugin for ensuring that wiki-style links are preserved during formatting.";
    homepage = "https://github.com/tmr232/mdformat-wikilink";
    license = licenses.mit;
    maintainers = with maintainers; [ MattKang ];
  };
}
