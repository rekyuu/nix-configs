{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
  scipy
}:

buildPythonPackage rec {
  pname = "libigl";
  version = "2.6.1";
  format = "wheel";

  src = fetchPypi rec {
    inherit pname version format;

    dist = python;
    python = "cp312";
    abi = "abi3";
    platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
    hash = "sha256-j9SPhnZj33/QUkRMEOsfocMDrMhuQBYGeXK0qrCuRYg=";
  };

  # do not run tests
  doCheck = false;

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    numpy
    scipy
  ];

  meta = {
    description = "libigl python bindings";
    homepage = "https://github.com/libigl/libigl-python-bindings";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rekyuu ];
  };
}
