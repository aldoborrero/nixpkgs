{
  buildPythonPackage,
  fetchPypi,
  lib,
  llm,
  pytestCheckHook,
  pythonOlder,
  sentence-transformers,
  setuptools,
}:

buildPythonPackage rec {
  pname = "llm-clip";
  version = "0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/Nfv5xpVFwtTDDDb9AiNivgMclYtyF29bsSDJFJdu34=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    sentence-transformers
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llm_clip"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-clip";
    description = "Generate embeddings for images and text using CLIP with LLM";
    changelog = "https://github.com/simonw/llm-clip/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
