{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    # Oh-My-Zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "sudo"
        "history"
        "extract"
        "command-not-found"
        "colored-man-pages"
      ];
      theme = "robbyrussell"; # This will be overridden by p10k
    };
    
    # Additional plugins not in oh-my-zsh
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = pkgs.writeTextFile {
          name = "p10k.zsh";
          text = ''
            # Generated p10k config - minimal catppuccin configuration
            'builtin' 'local' '-a' 'p10k_config_opts'
            [[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
            [[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
            [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
            'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

            () {
              emulate -L zsh -o extended_glob

              # Catppuccin Mocha color palette
              local rosewater='#f5e0dc'
              local flamingo='#f2cdcd'
              local pink='#f5c2e7'
              local mauve='#cba6f7'
              local red='#f38ba8'
              local maroon='#eba0ac'
              local peach='#fab387'
              local yellow='#f9e2af'
              local green='#a6e3a1'
              local teal='#94e2d5'
              local sky='#89dceb'
              local sapphire='#74c7ec'
              local blue='#89b4fa'
              local lavender='#b4befe'
              local text='#cdd6f4'
              local subtext1='#bac2de'
              local subtext0='#a6adc8'
              local overlay2='#9399b2'
              local overlay1='#7f849c'
              local overlay0='#6c7086'
              local surface2='#585b70'
              local surface1='#45475a'
              local surface0='#313244'
              local base='#1e1e2e'
              local mantle='#181825'
              local crust='#11111b'

              # Left prompt segments
              typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
                dir                     # current directory
                vcs                     # git status
              )

              # Right prompt segments
              typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
                status                  # exit code
                command_execution_time  # duration of last command
                background_jobs         # presence of background jobs
                virtualenv              # python virtual environment
                time                    # current time
              )

              # Basic settings
              typeset -g POWERLEVEL9K_MODE=nerdfont-complete
              typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
              typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
              typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{$blue}❯%f "

              # Directory customization
              typeset -g POWERLEVEL9K_DIR_BACKGROUND=$blue
              typeset -g POWERLEVEL9K_DIR_FOREGROUND=$base
              typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
              typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

              # VCS (git) customization
              typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$green
              typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$yellow
              typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$red
              typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$base
              typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$base
              typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$base

              # Status (exit code) customization
              typeset -g POWERLEVEL9K_STATUS_OK=false
              typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=$red
              typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$text

              # Command execution time
              typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
              typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$overlay2
              typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$text

              # Background jobs
              typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=$peach
              typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$base

              # Python virtual environment
              typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=$teal
              typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$base

              # Time
              typeset -g POWERLEVEL9K_TIME_BACKGROUND=$overlay0
              typeset -g POWERLEVEL9K_TIME_FOREGROUND=$text
              typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

              # Transient prompt
              typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

              # Instant prompt
              typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
              
              # Advanced Catppuccin-specific p10k settings could go here
              # ...
            }

            # Temporarily change options.
            'builtin' 'local' '-a' 'p10k_config_opts'
            [[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
            [[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
            [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
            'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

            # Restore options.
            if [ "''${#p10k_config_opts}" -eq 0 ]; then
  	      true
	    else
  	      'builtin' 'setopt' "''${p10k_config_opts[@]}"
	    fi
            'builtin' 'unset' 'p10k_config_opts'
          '';
          destination = "/p10k.zsh";
        };
        file = "p10k.zsh";
      }
    ];
    
    # Additional shell aliases
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake ~/.config/nixos#nixos";
      zz = "z -"; # Jump back to previous directory with zoxide
    };
    
    # Initialize plugins and other zsh customizations
    initExtra = ''
      # Load Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Additional zsh customizations
      setopt AUTO_CD              # Auto cd into directory by just typing its name
      setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
      
      # Use modern completion system
      autoload -Uz compinit
      compinit
      
      # Initialize zoxide (better cd command)
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    '';
  };

  # Make sure required packages are installed
  home.packages = with pkgs; [
    zoxide             # Smarter cd command
    fzf                # Fuzzy finder
    bat                # Better cat
    eza                # Better ls
    ripgrep            # Better grep
    fd                 # Better find
  ];
  
  # Set ZSH as the default shell
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
}
