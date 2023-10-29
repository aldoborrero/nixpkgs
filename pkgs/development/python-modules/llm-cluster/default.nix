{
  buildPythonPackage,
  fetchPypi,
  lib,
  llm,
  pytestCheckHook,
  scikit-learn,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llm-cluster";
  version = "0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nnnbC9P3/rP3Ov2sHK9ZR9pfsvQ7387TZUnMNJ0mvCg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  pythonImportsCheck = [
    "llm_cluster"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-cluster";
    description = "LLM plugin for clustering embeddings";
    changelog = "https://github.com/simonw/llm-cluster/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
