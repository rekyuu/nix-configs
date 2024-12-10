{ buildDotnetGlobalTool, lib, pkgs }:

buildDotnetGlobalTool {
  pname = "dotnet-ef";
  version = "9.0.0";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;

  nugetSha256 = "sha256-/Ru/H2WXX/SCqF2s0M1DJkaw+6Nikm+ccrveqiOXggA=";

  meta = with lib; {
    homepage = "https://github.com/dotnet/efcore";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}