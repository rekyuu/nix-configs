{
  inputs,
  lib,
  pkgs,
  ...
}: { 
  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions; [
      zhuangtongfa.material-theme
      jnoortheen.nix-ide
    ];

    userSettings = {
      "editor.find.addExtraSpaceOnTop" = false;
      "editor.fontFamily" = "'Cascadia Code', 'Noto Color Emoji', 'monospace', monospace";
      "editor.fontLigatures" = "'calt', 'ss01'";
      "editor.fontWeight" = "normal";
      "editor.inlineHints.fontFamily" = "'Cascadia Code', 'Noto Color Emoji', 'monospace', monospace";
      "editor.minimap.enabled" = false;
      "editor.semanticHighlighting.enabled" = true;
      "editor.wordWrap" = "on";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "security.workspace.trust.untrustedFiles" = "open";
      "window.autoDetectColorScheme" = true;
      "window.autoDetectHighContrast" = false;
      "window.menuBarVisibility" = "compact";
      "window.titleBarStyle" = "custom";
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.editor.empty.hint" = "hidden";
      "workbench.colorTheme" = "One Dark Pro";
      "workbench.preferredDarkColorTheme" = "One Dark Pro";
    };
  };
}