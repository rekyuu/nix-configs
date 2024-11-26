{
  pkgs,
  ...
}: { 
  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions; [
      hashicorp.hcl
      zhuangtongfa.material-theme  
      jnoortheen.nix-ide
      timonwong.shellcheck
      hashicorp.terraform
    ];

    userSettings = {
      "editor.find.addExtraSpaceOnTop" = false;
      "editor.fontFamily" = "'Cascadia Code', 'Noto Color Emoji', 'monospace', monospace";
      "editor.fontLigatures" = "'calt', 'ss01'";
      "editor.fontWeight" = "normal";
      "editor.minimap.enabled" = false;
      "editor.semanticHighlighting.enabled" = true;
      "editor.wordWrap" = "on";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
        };
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "update.mode" = "none";
      "window.autoDetectColorScheme" = false;
      "window.autoDetectHighContrast" = false;
      "window.menuBarVisibility" = "compact";
      "window.titleBarStyle" = "custom";
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.editor.empty.hint" = "hidden";
      "workbench.colorTheme" = "One Dark Pro";
      "workbench.preferredDarkColorTheme" = "One Dark Pro";
      "workbench.preferredLightColorTheme" = "One Dark Pro";
    };
  };
}