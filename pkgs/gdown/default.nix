# https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/development/python-modules/gdown/default.nix#L47
{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "gdown";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NhxuBMbKM131C51x9AvP6atw+yahsOiQpCcmd4E4lVM=";
  };

  build-system = [
    python3Packages.hatchling
    python3Packages.hatch-vcs
    python3Packages.hatch-fancy-pypi-readme
  ];

  dependencies = [
    python3Packages.beautifulsoup4
    python3Packages.filelock
    python3Packages.requests
    python3Packages.setuptools
    python3Packages.tqdm
  ]
  ++ python3Packages.requests.optional-dependencies.socks;

  checkPhase = ''
    $out/bin/gdown --help > /dev/null
  '';

  pythonImportsCheck = [ "gdown" ];

  meta = {
    description = "CLI tool for downloading large files from Google Drive";
    homepage = "https://github.com/wkentaro/gdown";
    changelog = "https://github.com/wkentaro/gdown/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ breakds ];
    mainProgram = "gdown";
  };
}