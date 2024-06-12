{...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "Cascadia Code";
      size = 11;
    };

    settings = {
      disable_ligatures = "never";
      url_style = "single";
      copy_on_select = "yes";
      window_padding_width = "10 12";
      tab_bar_style = "separator";
      tab_separator = "";
      tab_title_template = " {title} ";
      active_tab_font_style = "bold-italic";
      inactive_tab_font_style = "normal";
      tab_bar_background = "none";
      allow_remote_control = "yes";
      background_opacity = 1;
      confirm_os_window_close = 0;
      kitty_mod = "ctrl";
    };

    extraConfig = ''
      map kitty_mod+c copy_and_clear_or_interrupt
      map kitty_mod+l clear_terminal scroll active

      # Base16 Seti UI - kitty color config
      # Scheme by 
      background #151718
      foreground #d6d6d6
      selection_background #d6d6d6
      selection_foreground #151718
      url_color #43a5d5
      cursor #d6d6d6
      active_border_color #41535B
      inactive_border_color #282a2b
      active_tab_background #151718
      active_tab_foreground #d6d6d6
      inactive_tab_background #282a2b
      inactive_tab_foreground #43a5d5
      tab_bar_background #282a2b

      # normal
      color0 #151718
      color1 #Cd3f45
      color2 #9fca56
      color3 #e6cd69
      color4 #55b5db
      color5 #a074c4
      color6 #55dbbe
      color7 #d6d6d6

      # bright
      color8 #41535B
      color9 #Cd3f45
      color10 #9fca56
      color11 #e6cd69
      color12 #55b5db
      color13 #a074c4
      color14 #55dbbe
      color15 #ffffff

      # extended base16 colors
      color16 #db7b55
      color17 #8a553f
      color18 #282a2b
      color19 #3B758C
      color20 #43a5d5
      color21 #eeeeee
    '';
  };
}