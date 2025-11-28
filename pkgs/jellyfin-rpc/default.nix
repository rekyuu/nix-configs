{ 
  lib,
  rustPlatform,
  fetchFromGitHub
}: rustPlatform.buildRustPackage rec {
  pname = "jellyfin-rpc";
  version = "1.3.4";
  
  src = fetchFromGitHub {
    owner = "Radiicall";
    repo = "jellyfin-rpc";
    rev = version;
    hash = "sha256-zKqP6Wt38ckqCPDS1oncmx92lZJm2oeb3bfpwVc6fUc=";
  };

  cargoHash = "sha256-k9dGz+1HGcQoDMyqmJ1hEYklfYHibo1PI5jHEe0mr+w=";

  meta = with lib; {
    description = "Displays the content you're currently watching on Discord";
    homepage = "https://github.com/Radiicall/jellyfin-rpc";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    mainProgram = "jellyfin-rpc";
  };
}