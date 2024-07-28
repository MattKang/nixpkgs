{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdformat-footnote,
  mdformat-frontmatter,
  mdformat-tables,
  mdit-py-plugins,
  pytestCheckHook,
  pythonOlder,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "mdformat-myst";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "mdformat-myst";
    rev = "e46ee9b82a26a39cd4fd30cb27fc9161c71dd44e";
    hash = "sha256-B8RGwJsauqOxJPdqhOassTDgoGc+SUaB8Ols2KGDwP4=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdformat-footnote
    mdformat-frontmatter
    mdformat-tables
    mdit-py-plugins
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_myst" ];

  meta = with lib; {
    description = "Mdformat plugin for MyST compatibility";
    homepage = "https://github.com/kdeldycke/mdformat-myst";
    license = licenses.mit;
    maintainers = with maintainers; [ MattKang ];
  };
}
