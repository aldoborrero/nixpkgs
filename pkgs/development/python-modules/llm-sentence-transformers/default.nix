{
  buildPythonPackage,
  fetchPypi,
  lib,
  llm,
  pytestCheckHook,
  sentence-transformers,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llm-sentence-transformers";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AED7lIRmMp7nkoJQE540Rdo4XKCaorYVQOQolN8HQjE=";
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

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  pythonImportsCheck = [
    "llm_sentence_transformers"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-sentence-transformers";
    description = "LLM plugin for embeddings using sentence-transformers";
    changelog = "https://github.com/simonw/llm-sentence-transformers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
