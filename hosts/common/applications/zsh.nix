{
  config,
  lib,
  ...
}: {
  options.zsh.promptColor = lib.mkOption {
    type = lib.types.str;
    default = "red";
  };

  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ls = "ls -Ahl --color=auto --group-directories-first";
        py = "python";
        tree = "tree -la";
        blender3 = "nix run blender-bin#blender_3_6";
      };

      envExtra = ''
        TERM="xterm-256color"
      '';

      initContent = ''
        # Keybinds
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "^[[3~" delete-char

        # Prompt customization
        autoload -U colors && colors
        autoload -Uz vcs_info
        setopt prompt_subst

        zstyle ':vcs_info:*' enable git svn
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:*' actionformats "%B%F{green}%c%u%f %B%b%f"
        zstyle ':vcs_info:*' formats "%B%F{green}%c%u%f %B%b%f"

        precmd() { vcs_info }

        ITALICS_START=$'%{\e[3m%}'
        ITALICS_END=$'%{\e[0m%}'

        PROMPT=$'%B%n@%m %F{${config.zsh.promptColor}}%2~%f »%b '
        RPROMPT="''${vcs_info_msg_0_}"

        # Syntax highlighting
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
        typeset -A ZSH_HIGHLIGHT_STYLES

        ZSH_HIGHLIGHT_STYLES[arg0]='fg=blue,bold'
        ZSH_HIGHLIGHT_STYLES[path]=none
        ZSH_HIGHLIGHT_STYLES[precommand]='fg=blue,bold'
        ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'

        # direnv
        eval "$(direnv hook zsh)"
      '';
    };
  };
}