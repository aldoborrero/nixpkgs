{
  black,
  buildPythonApplication,
  buildPythonPackage,
  cogapp,
  fetchPypi,
  lib,
  makeWrapper,
  mypy,
  numpy,
  pytestCheckHook,
  python3,
  pythonOlder,
  requests-mock,
  ruff,
  setuptools,
  types-pyyaml,
  types-click,
  types-requests,
  types-setuptools,
}: let
  withPlugins = plugins:
    buildPythonApplication {
      inherit (llm) pname version;
      format = "other";

      disabled = pythonOlder "3.8";

      dontUnpack = true;
      dontBuild = true;
      doCheck = false;

      nativeBuildInputs = [
        makeWrapper
      ];

      installPhase = ''
        makeWrapper ${llm}/bin/llm $out/bin/llm \
          --prefix PYTHONPATH : "${llm}/${python3.sitePackages}:$PYTHONPATH"
        ln -sfv ${llm}/lib $out/lib
      '';

      propagatedBuildInputs = llm.propagatedBuildInputs ++ plugins;

      passthru =
        llm.passthru
        // {
          withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
        };

      meta.mainProgram = "llm";
    };

  llm = buildPythonPackage rec {
    pname = "llm";
    version = "0.11";
    pyproject = true;

    disabled = pythonOlder "3.8";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-/AnIvVPNQXgHxwzCsk9cGsCRX0WAhDSglUamLB7fNv0=";
    };

    nativeBuildInputs = [
      setuptools
    ];

    propagatedBuildInputs = with python3.pkgs; [
      click-default-group
      openai
      pip
      pluggy
      pydantic
      python-ulid
      pyyaml
      sqlite-migrate
      sqlite-utils
    ];

    nativeCheckInputs = [
      pytestCheckHook
      numpy
      requests-mock
      cogapp
      mypy
      black
      ruff
      types-click
      types-pyyaml
      types-requests
      types-setuptools
    ];

    doCheck = false;

    pythonImportsCheck = [
      "llm"
    ];

    passthru = {inherit withPlugins;};

    meta = with lib; {
      homepage = "https://github.com/simonw/llm";
      description = "Access large language models from the command-line";
      changelog = "";
      license = licenses.asl20;
      mainProgram = "llm";
      maintainers = with maintainers; [aldoborrero];
    };
  };
in
  llm
