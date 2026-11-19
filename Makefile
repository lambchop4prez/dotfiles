# Day-2 operations (run from the dotfiles repo).
# chezmoi lives in .homebrew/bin after scripts/install-chezmoi.sh.
CJ := .homebrew/bin/chezmoi

.PHONY: apply update diff check

apply: ## re-apply dotfiles (fast, no software changes)
	$(CJ) apply -v

update: ## refresh software: brew update + upgrade, then dump drift into Brewfile
	brew update
	brew upgrade
	brew bundle dump --global --force
	@echo "--- review with: git diff ~/.Brewfile (i.e. Brewfile in this repo); commit what you want to keep"

diff: ## show what the Brewfile dump would change (needs `update` first)
	git diff -- Brewfile

check: ## verify no drift between repo and $HOME (like nix verify)
	$(CJ) verify
