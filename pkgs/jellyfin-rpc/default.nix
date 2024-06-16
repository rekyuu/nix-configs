{ 
  lib,
  rustPlatform,
  fetchFromGitHub
}: rustPlatform.buildRustPackage rec {
  pname = "jellyfin-rpc";
  version = "1.1.0";
  
  src = fetchFromGitHub {
    owner = "Radiicall";
    repo = "jellyfin-rpc";
    rev = version;
    hash = "sha256-VKwqEboyA7PZLA/ceixQ/vSZUSD7XKUfcfmHVXrsooA=";
  };

  cargoHash = "sha256-q0SeM2XfRVQckDyhkTRlT4+eXhqc5lidzChxnwiZqcM=";

  meta = with lib; {
    description = "Displays the content you're currently watching on Discord";
    homepage = "https://github.com/Radiicall/jellyfin-rpc";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    mainProgram = "jellyfin-rpc";
  };
}