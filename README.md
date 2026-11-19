# Bootstrap a new Mac without `curl | sh`

This repo replaces `~/Source/nix-config` with chezmoi. The trust model is the
one flake.lock gave you: **everything is version-pinned and hash-verified.**

## One-time bootstrap (the only manual step)

```sh
git clone git@github.com:lambchop4prez/dotfiles.git ~/dotfiles
sh ~/dotfiles/scripts/install-chezmoi.sh   # read it first — that's the point
~/dotfiles/.homebrew/bin/chezmoi init --apply --source ~/dotfiles
```

`install-chezmoi.sh` downloads a pinned chezmoi release, verifies its SHA-256
against the checksums file published with that release, and installs it into
the repo-local `.homebrew/bin/`. No sudo, no pipe-to-shell, no `PATH`
modifications. (Alternatives: the signed `.pkg` on chezmoi's GitHub releases,
or `brew install chezmoi` once Homebrew exists.)

## What runs on `chezmoi apply`

| Script | Replaces | When |
|---|---|---|
| `.chezmoiscripts/run_once_homebrew.sh` | nix-homebrew + the curl installer | first apply (pinned git clone, SHA-verified) |
| `.chezmoiscripts/run_once_macos_defaults.sh` | `system.defaults` in nix-darwin | first apply, and whenever `.chezmoidata/macos.toml` changes |
| `.chezmoiscripts/run_onchange_brewfile.sh` | `homebrew.brews/casks` + `onActivation` | whenever `~/.Brewfile` changes |

Files: `~/.zshrc`, `~/.zprofile`, `~/.zsh_plugins.txt`, `~/.p10k.zsh`,
`~/.gitconfig`, `~/.config/git/ignore`, `~/.config/mise/config.toml`, `~/.Brewfile`.

## Day-2 operations

```sh
make update        # brew update + upgrade + dump drifted state into Brewfile
make diff          # git diff of the regenerated Brewfile — this is your PR
chezmoi diff       # what would change in your dotfiles
chezmoi verify     # drift detection (like nix's store-hash check)
```

Note: `run_*` scripts execute in full on a real `chezmoi apply` — chezmoi can
preview files (`chezmoi diff`) and skips scripts under `-n`, but it cannot
sandbox a script's side effects. Render one first with
`chezmoi cat ~/.chezmoiscripts/<name>.sh` (check with `sh -n`) if unsure.

`brew bundle --global --force --no-upgrade` (run by `make update`) **removes**
formulae/casks no longer in the Brewfile — the `cleanup = "uninstall"` you had
commented out in nix-darwin, but opt-in via git instead of on every activation.

## Decommissioning Nix (after a clean chezmoi apply + reboot)

```sh
sudo nix-uninstallers/nix-install-* uninstall 2>/dev/null || \
  { sudo pkill -f nixd; sudo rm -rf /nix /var/root/.nix-profile /etc/profile.d/nix*; }
sudo rm -f /etc/zsh{env,rc,profile}.bak 2>/dev/null  # only if nix touched them
# remove nix's user launchd plists, then remove the nix trusted user / Nix
# Computer Management users via System Settings, and UserShell is already /bin/zsh
```

Then: `brew bundle dump --global --force` on each remaining Mac to capture
whatever they installed ad-hoc, and reconcile.
