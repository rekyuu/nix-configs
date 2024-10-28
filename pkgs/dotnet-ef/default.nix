{ buildDotnetGlobalTool, lib, pkgs }:

buildDotnetGlobalTool {
  pname = "dotnet-ef";
  version = "8.0.10";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;

  nugetSha256 = "sha256-J12XiJquBNUp3OwHdv43hIFoaJ9dz2P6BEIzgZf+w0I=";

  meta = with lib; {
    homepage = "https://github.com/dotnet/efcore";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}