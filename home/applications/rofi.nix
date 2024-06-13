{...}: {
  programs.rofi = {
    enable = true;
    theme = {
      configuration = {
        show-icons = true;
        m = "primary";
        display-drun = "<b>rekyuu@ikuyo <span foreground='#cd3f45'>share/applications</span> »</b>";
        display-run = "<b>rekyuu@ikuyo <span foreground='#cd3f45'>~</span> »</b>";
        disable-history = false;
        modes = [ "drun" "run" ];
      };

      entry = {
        placeholder = "";
      };

      "*" = {
        font = "Cascadia Code 11";
        foreground = "#d6d6d6";
        background-color = "#151718";
        active-foreground = "@background-color";
        active-background = "@foreground";
        urgent-foreground = "#cd3f45";
        urgent-background = "@background-color";
        selected-background = "@foreground";
        selected-urgent-background = "@urgent-foreground";
        selected-active-background = "@foreground";
        separatorcolor = "@background-color";
        bordercolor = "@background-color";
      };

      window = {
        background-color = "@background-color";
        border = 0;
        border-radius = 0;
        border-color = "@background-color";
        padding = "10 12";
        width = "36em";
      };

      mainbox = {
        border = 0;
        padding = 0;
      };

      prompt = {
        font = "Cascadia Code 11 Bold";
        margin = "0px 0.25em 0em 0em";
        text-color = "@foreground";
        markup = true;
      };

      textbox-prompt-colon = {
        expand = false;
        str = "";
        margin = "0em 0em 0em 0.33em";
        text-color = "@foreground";
      };

      listview = {
        scrollbar = false;
      };

      "element normal normal" = {
        background-color = "@background-color";
        text-color = "@foreground";
      };

      "element alternate normal" = {
        background-color = "@background-color";
        text-color = "@foreground";
      };

      "element selected normal" = {
        background-color = "@foreground";
        text-color = "@background-color";
      };
    };
  };
}