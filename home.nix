

{ config, pkgs, hyprland, ... }:

{

  imports = [
  ./modules/desktop/hyprland.nix
  ];

  home.username = "pentester";
  home.homeDirectory = "/home/pentester";
  home.stateVersion = "24.11";

  # ================================
  # NEOVIM — tunado pra cybersec/dev
  # ================================
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      # LSP servers
      clang-tools
      pyright
      ruff
      bash-language-server
      rust-analyzer
      rustc
      cargo
      nil

      # Debug / build
      cmake
      gdb
      python3

      # Telescope deps
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      (nvim-treesitter.withPlugins (p: [
        p.cpp p.c p.lua p.nix p.python p.bash p.json p.yaml p.markdown p.rust p.asm
      ]))

      telescope-nvim
      plenary-nvim

      gitsigns-nvim
      lualine-nvim
      nvim-web-devicons
      nvim-tree-lua
      comment-nvim
      indent-blankline-nvim
      trouble-nvim
    ];

    initLua = ''
      -- Treesitter
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'cpp', 'c', 'lua', 'nix', 'python', 'bash', 'json', 'yaml', 'markdown', 'rust', 'asm' },
        callback = function()
          vim.treesitter.start()
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })

      -- LSP servers
      vim.lsp.config('clangd', {})
      vim.lsp.enable('clangd')

      vim.lsp.config('pyright', {})
      vim.lsp.enable('pyright')

      vim.lsp.config('bashls', {})
      vim.lsp.enable('bashls')

      vim.lsp.config('rust_analyzer', {})
      vim.lsp.enable('rust_analyzer')

      vim.lsp.config('nil_ls', {})
      vim.lsp.enable('nil_ls')

      -- Autocomplete
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -- Telescope
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})

      -- LSP navigation
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})

      -- File explorer
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})

      -- Diagnostics
      vim.keymap.set('n', '<leader>xx', ':Trouble diagnostics toggle<CR>', {})

      require('Comment').setup()
      require('lualine').setup({ options = { theme = 'auto' } })
      require('gitsigns').setup()
      require('ibl').setup()

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.opt.clipboard = 'unnamedplus'
    '';
  };

  # ================================
  # ZSH — aliases gerais + cybersec workflow
  # ================================
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # --- sistema / manutenção ---
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#cybersec-vm";
      update = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos#cybersec-vm && cd -";
      nixgarbage = "sudo nix-collect-garbage -d";

      # --- recon rápido ---
      myip = "curl -s ifconfig.me";
      localip = "ip -4 addr show | grep inet | grep -v 127.0.0.1";
      ports = "sudo ss -tulnp";
      openports = "nmap -p- --min-rate=1000 -T4";
      quickscan = "nmap -sV -sC -oN scan.txt";

      # --- servidores rápidos (exfil / transferência em CTF) ---
      serve = "python3 -m http.server 8000";
      serveup = "python3 -c \"import http.server, cgi; http.server.test(HandlerClass=http.server.CGIHTTPRequestHandler)\"";

      # --- encode / decode comuns ---
      b64d = "base64 -d";
      b64e = "base64 -w0";
      urldecode = "python3 -c \"import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))\"";
      urlencode = "python3 -c \"import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))\"";

      # --- hashing rápido ---
      md5 = "md5sum";
      sha1 = "sha1sum";
      sha256 = "sha256sum";

      # --- rede / captura ---
      sniff = "sudo tcpdump -i any -w capture.pcap";

      # --- utilidades ---
      ff = "fd";
      grepr = "rg";
      cls = "clear";
    };
  };

  # ================================
  # STARSHIP
  # ================================
programs.starship = {
  enable = true;
  settings = {
    add_newline = false;
    format = "[](fg:#FF2079) [$directory](fg:#00F0FF)$git_branch [$character]($style)";
    directory = {
      format = "$path";
      truncation_length = 2;
      truncation_symbol = "…/";
    };
    git_branch.format = " [ $branch](fg:#F9E900)";
    character = {
      success_symbol = "[❯](fg:#39FF14)";
      error_symbol = "[❯](fg:red)";
    };
  };
};

  # ================================
  # KITTY
  # ================================
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
    };
  };

  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
}