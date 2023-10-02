{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  lz4,
  snappy,
  stdenv,
  writeText,
  zstd,
}: let
  nuget-config = writeText "nuget.config" ''
    <configuration>
      <packageSources>
        <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
      </packageSources>
    </configuration>
  '';
in
  buildDotnetModule rec {
    pname = "recyclarr";
    version = "6.0.0";

    src = fetchFromGitHub {
      owner = "recyclarr";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-ba3fdbOYIhqisF0Vn4ETyAWPqzoAZXcDJrBac8Jpt+E=";
    };

    buildInputs = [
      lz4
      snappy
      stdenv.cc.cc.lib
      zstd
    ];

    doCheck = false;

    patches = [
      ./001-Git-Version.patch
    ];

    projectFile = ["src/Recyclarr.Cli/Recyclarr.Cli.csproj"];

    nugetDeps = ./nuget-deps.nix;

    executables = ["recyclarr"];

    dotnet-sdk = dotnetCorePackages.sdk_7_0;
    dotnet-runtime = dotnetCorePackages.runtime_7_0;
    dotnet-test-sdk = dotnetCorePackages.sdk_7_0;

    dotnetRestoreFlags = ["--configfile=${nuget-config}"];

    meta = with lib; {
      description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances.";
      homepage = "https://github.com/recyclarr/recyclarr";
      license = licenses.gpl3;
      maintainers = with maintainers; [josephst aldoborrero];
    };
  }
