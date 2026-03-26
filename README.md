# zsh-template

Zimfw-based Zsh template.

The repository keeps module definitions in `config/zimrc`.

## One-Click Install (zimrc only)

```zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/wuyaos/zsh-template/main/scripts/install-zimrc.sh)"
```

What it does:

1. Downloads and installs `config/zimrc` from GitHub to `~/.zimrc`.
2. Backs up existing `~/.zimrc` when needed.
3. Runs `zimfw init/install/compile`.
4. Does **not** modify `~/.zshrc`.

Then reload shell:

```zsh
exec zsh
```

## Optional Overrides

```zsh
GITHUB_REPO="wuyaos/zsh-template" GITHUB_BRANCH="main" sh -c "$(curl -fsSL https://raw.githubusercontent.com/wuyaos/zsh-template/main/scripts/install-zimrc.sh)"
```

## Quick Verify

```zsh
ls -l ~/.zimrc
bindkey -M emacs '^I'
bindkey -M viins '^I'
whence -w fzf-tab-complete
```

Expected:

1. `~/.zimrc` file content matches this repo's `config/zimrc`.
2. `^I` is bound to `fzf-tab-complete` in emacs/viins keymaps.
3. `fzf-tab-complete` resolves as a function.
