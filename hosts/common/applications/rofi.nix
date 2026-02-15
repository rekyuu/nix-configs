{
  config,
  ...
}: 
let
  inherit (config.lib.formats.rasi) mkLiteral;

  backgroundColor = "#151718";
  foregroundColor = "#d6d6d6";
  urgentColor = "#cd3f45";
in {
  programs.rofi = {
    enable = true;

    font = "Cascadia Code 11";
    theme = {
      configuration = {
        show-icons = true;
        m = "primary";
        display-drun = "<b>rekyuu@ikuyo <span foreground='${urgentColor}'>share/applications</span> »</b>";
        display-run = "<b>rekyuu@ikuyo <span foreground='${urgentColor}'>~</span> »</b>";
        disable-history = false;
        modes = map mkLiteral [ "drun" "run" ];
      };

      entry = {
        placeholder = "";
      };

      "*" = {
        text-color = mkLiteral foregroundColor;
        background-color = mkLiteral backgroundColor;
        separatorcolor = mkLiteral backgroundColor;
        bordercolor = mkLiteral backgroundColor;
      };

      "normal.active" = {
        text-color = mkLiteral backgroundColor;
        background-color = mkLiteral foregroundColor;
      };

      "normal.urgent" = {
        text-color = mkLiteral urgentColor;
        background-color = mkLiteral backgroundColor;
      };

      "selected" = {
        text-color = mkLiteral backgroundColor;
        background-color = mkLiteral foregroundColor;
      };

      "selected.active" = {
        text-color = mkLiteral backgroundColor;
        background-color = mkLiteral foregroundColor;
      };

      "selected.urgent" = {
        text-color = mkLiteral backgroundColor;
        background-color = mkLiteral urgentColor;
      };

      window = {
        background-color = mkLiteral backgroundColor;
        border-color = mkLiteral backgroundColor;
        border = 0;
        border-radius = 0;
        padding = mkLiteral "10 12";
        width = mkLiteral "36em";
      };

      mainbox = {
        border = 0;
        padding = 0;
      };

      prompt = {
        text-color = mkLiteral foregroundColor;
        margin = mkLiteral "0px 0.25em 0em 0em";
        markup = true;
      };

      textbox-prompt-colon = {
        text-color = mkLiteral foregroundColor;
        expand = false;
        str = "";
        margin = mkLiteral "0em 0em 0em 0.33em";
      };

      listview = {
        scrollbar = false;
      };

      "element normal normal" = {
        text-color = mkLiteral foregroundColor;
        background-color = mkLiteral backgroundColor;
      };

      "element alternate normal" = {
        text-color = mkLiteral foregroundColor;
        background-color = mkLiteral backgroundColor;
      };

      "element selected normal" = {
        text-color = mkLiteral backgroundColor;
        background-color = mkLiteral foregroundColor;
      };
    };
  };
}