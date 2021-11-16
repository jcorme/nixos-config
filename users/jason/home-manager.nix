{ config, lib, pkgs, ... }:

{
  # Let Home Manager manager XDG base directories.
  xdg = {
    enable = true;

    # Manually-managed configuration files
    configFile."i3/config".text = builtins.readFile ./i3;
  };

  home = {
    # Packages that should always be available to me.
    packages = with pkgs; [
      # Tools
      fd
      fzf
      htop
      ripgrep
      xclip
    ];

    # Environment variables for all sessions.
    sessionVariables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
      TERMINAL = "kitty";
    };
  };

  # Enable fontconfig configuration so cache gets updated when font package is installed.
  fonts.fontconfig.enable = true;

  # Configuration of individual programs.
  programs.direnv = {
    enable = true;

    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  programs.git = {
    enable = true;

    userEmail = "jason@jcndrop.com";
    userName = "Jason Chen";

    lfs.enable = true;

    extraConfig = {
      color.ui = true;
      init.defaultBranch = "main";
    };
  };

  programs.home-manager = {
    enable = true;
  };

  programs.i3status = {
    enable = true;
    general.colors = true;

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [
      "--quiet"
      "--nogui"
    ];
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = false;
    withPython3 = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      fzf-vim
      rust-vim
      nerdcommenter
      vim-nix
      base16-vim
    ];

    extraConfig = ''
      let base16colorspace=256
      set termguicolors
      colorscheme base16-tomorrow-night
      set background=dark
      autocmd ColorScheme *
        \ hi Normal ctermbg=black guibg=black

      set number
      set relativenumber

      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set smarttab
      set expandtab

      " Makes the system clipboard work.
      set clipboard+=unnamedplus
      " See substitions while typing.
      set inccommand=nosplit

      " Exit insert mode using j and k.
      inoremap jk <Esc>

      " Fuzzy search and open files
      nnoremap <leader>f :Files<cr>
      " Fuzzy search through open buffers
      nnoremap <leader>b :Buffers<cr>

      " Search through files
      command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --glob "!.gitignore" --glob "!package-lock.json" --color "always" '.shellescape(<q-args>).' | tr -d "\017"', 1, <bang>0)
      nnoremap <leader>s :Find<cr>

      hi Normal ctermbg=black guibg=black
    '';
  };

  programs.tmux = {
    enable = true;

    baseIndex = 1;
    escapeTime = 1;
    historyLimit = 102400;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "xterm-256color";

    extraConfig = ''
      # set -as terminal-overrides ",*-256color:Tc"

      # Use vi bindings to navigate buffer (copy-mode)
      # setw -g mode-keys vi

      # Renumber windows after a window is closed
      set -g renumber-windows on

      # Disable mouse
      set -g mouse off

      # Add PATH as an environment variable to update when attaching
      set -ga update-environment ' PATH'

      # Prevent sessions from syncing their window sizes
      # setw -g aggressive-resize on

      # Move between panes
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key h select-pane -L
      bind-key l select-pane -R

      # Resize panes
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r H resize-pane -L 5
      bind-key -r L resize-pane -R 5

      # Cycle through panes (- left; + right)
      bind-key -r C-h select-window -t :-
      bind-key -r C-l select-window -t :+

      # Split window (horizontal/vertical)
      bind-key t split-window
      bind-key v split-window -h

      # Reload configuration and display message
      bind-key R source-file ~/.tmux.conf \; display "Reloaded!"

      # Move windows left/right
      bind-key -r > swap-window -t :+
      bind-key -r < swap-window -t :-

      # Move back and forth between windows
      bind-key bspace previous-window
      bind-key space next-window

      # Input simultaneously to all panes
      bind-key * set-window-option synchronize-pane

      # Copy-mode; copy to clipboard
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -i"

      # Clear history buffer
      bind-key C-u send-keys C-u \; clear-history

      # Show window tree without previews
      bind-key w choose-tree -N
      # Show session tree without previews
      bind-key s choose-tree -Ns

      # Window fuzzy searcher with fzf
      bind-key f run -b ftwind

      # Status line
      set-option -g status-justify left
      #set-option -g status-left '#[bg=colour72] #[bg=colour237] #[bg=colour236] #[bg=colour235] '
      set-option -g status-left '#[bg=colour72] '
      set-option -g status-left-length 16
      set-option -g status-bg colour237
      set-option -g status-right '#[bg=colour236] #[bg=colour235]#[fg=colour185] #(date "+%B %d, %Y | %I:%M%p") | #h #[bg=colour236] #[bg=colour237] #[bg=colour72] '
      set-option -g status-interval 60

      set-option -g pane-border-status bottom
      set-option -g pane-border-format "#{pane_index} #{pane_current_command}"

      set-window-option -g window-status-format '#[bg=colour238]#[fg=colour107] #I #[bg=colour239]#[fg=colour110] #[bg=colour240]#W#[bg=colour239]#[fg=colour195]#F#[bg=colour238] '
      set-window-option -g window-status-current-format '#[bg=colour236]#[fg=colour215] #I #[bg=colour235]#[fg=colour167] #[bg=colour234]#W#[bg=colour235]#[fg=colour195]#F#[bg=colour236] '
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;

    history = rec {
      ignoreSpace = true;
      size = 9999999;
      save = size;
    };

    defaultKeymap = "viins";

    initExtraBeforeCompInit = ''
      setopt prompt_subst
    '';

    initExtra = ''
      autoload -U colors
      colors

      PROMPT=$'\n%B%F{161}%~%f%b %F{153}%*%f -- $?\n''${VIMODE} '

      # Leave Insert Mode
      bindkey 'jk' vi-cmd-mode

      # Open fzf cd widget for every directory in $HOME
      function fzf_alt_c_home() {
        FZF_ALT_C_COMMAND="$BASE_FZF_FD_CMD -t d . $HOME" fzf-cd-widget
      }
      zle -N fzf_alt_c_home

      function git_show_fuzzy_search() {
        git show `git log --format=oneline | fzf | awk '{print $1}'`
      }

      # Sets VIMODE indicating the current editing mode of the prompt
      # '$' for Insert Mode
      # Red 'I' for "Normal" Mode
      function zle-line-init zle-keymap-select {
          DOLLAR='%B%F{green}λ%f%b'
          GIANT_I='%B%F{red}I%f%b'
          VIMODE="''${''${KEYMAP/vicmd/$GIANT_I}/(main|viins)/$DOLLAR}"
          zle reset-prompt
      }
      zle -N zle-line-init
      zle -N zle-keymap-select

      # Fuzzy search through all directories in $HOME
      bindkey '\ed' fzf_alt_c_home

      bindkey '^w' autosuggest-accept
      bindkey '^e' autosuggest-execute

      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
    '';

    envExtra = ''
      export BASE_FZF_FD_CMD="fd -H -E '.git'"
      export FZF_DEFAULT_COMMAND="$BASE_FZF_FD_CMD ."
      export FZF_CTRL_T_COMMAND="$BASE_FZF_FD_CMD -E '*.DS_Store' -E '*.localized' ."
      export FZF_ALT_C_COMMAND="$BASE_FZF_FD_CMD -t d ."
    '';

    shellAliases = {
      rm = "rm -i";
      ls = "ls --color=auto";
      ll = "ls -al";

      rsyncp = "rsync -avz -e \"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\" --progress";
      rsyncpl = "rsync -av -e \"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\" --progress";

      nssh = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      nscp = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      gsfzf = "git_show_fuzzy_search";
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
  };

  xsession.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 96;
  };
}
