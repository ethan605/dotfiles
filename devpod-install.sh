#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${WORK_EMAIL++}" ]]; then
	echo "Error: WORK_EMAIL is unset"
	exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo add-apt-repository main -y &&
		sudo add-apt-repository universe -y &&
		sudo add-apt-repository restricted -y &&
		sudo add-apt-repository multiverse -y &&
		sudo apt upgrade -y &&
		sudo apt install --no-install-recommends -y \
			libyaml-dev python3-venv zsh &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/*

	curl -fsSL https://mise.run | sh

	mise use -g \
		awscli@latest \
		bat@latest \
		bottom@latest \
		chezmoi@latest \
		delta@latest \
		direnv@latest \
		eza@latest \
		fd@latest \
		fzf@latest \
		gcloud@latest \
		kubecolor@latest \
		kubectx@latest \
		kubens@latest \
		kustomize@latest \
		lua@latest \
		neovim@latest \
		nodejs@latest \
		opencode@latest \
		ripgrep@latest \
		rtk@latest \
		ruby@latest \
		rust@latest \
		starship@latest \
		tree-sitter@latest \
		uv@latest \
		vivid@latest \
		zoxide@latest

	eval "$(mise activate bash)"
}

__configure-bash() {
	rm -rf ~/.local/share/fzf-tab-completion
	git clone https://github.com/lincheney/fzf-tab-completion ~/.local/share/fzf-tab-completion

	mkdir -p ~/dotfiles
	rm -rf ~/dotfiles/.bashrc

	cat <<EOF >~/dotfiles/.bashrc
# shellcheck disable=SC2148
# === Environments ===
export BAT_THEME=base16
export EDITOR=nvim
export MANPAGER='nvim +Man!'

export FZF_DEFAULT_OPTS='
  --ansi
  --bind=ctrl-y:preview-up,ctrl-e:preview-down,ctrl-u:preview-page-up,ctrl-d:preview-page-down
  --color=fg+:7,bg+:0,hl:5,hl+:5
  --color=gutter:0,header:4,marker:2,pointer:5,prompt:2,spinner:3
  --cycle
  --marker="›"
  --pointer="›"
  --prompt="❯ "
  --reverse
  --no-height
'
export FZF_CTRL_R_OPTS='
  --preview="echo {2..} | bat --color=always --language=zsh --number --plain"
  --bind="ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort"
  --header="Press CTRL-Y to copy command into clipboard"
'

export PATH="\$HOME/.local/bin/:\$PATH"

# === Keybinds ===
bind "\C-w":backward-kill-word
bind "\C-h":backward-word         # left
bind "\C-l":forward-word          # right
bind "\C-k":previous-history      # up
bind "\C-j":next-history          # down
bind "\C-a":beginning-of-line
bind "\C-e":end-of-line

# === Plugins ===
eval "\$(mise activate bash)"     # must go first
eval "\$(direnv hook bash)"
eval "\$(fzf --bash)"
eval "\$(starship init bash)"
eval "\$(zoxide init bash)"

if [[ -f \$HOME/.local/share/fzf-tab-completion/bash/fzf-bash-completion.sh ]]; then
	# shellcheck disable=SC1091
	source "\$HOME/.local/share/fzf-tab-completion/bash/fzf-bash-completion.sh"
	bind -x '"\\t": fzf_bash_completion'
fi

# === Utils & aliases ===
__system-upgrade() {
	# shellcheck disable=SC2033
	cat "\$HOME/.config/devbox/\$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update &&
		sudo apt upgrade -y &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/*
}

__mise-upgrade() {
	mise self-update --yes &&
		mise plugins update &&
		mise upgrade --bump --interactive &&
		mise cache prune
}

__config-sync() {
	chezmoi git pull &&
		chezmoi apply --force &&
		nvim --headless \\
			-c 'Lazy! restore' \\
			-c MasonUpdate \\
			-c MasonLockRestore \\
			-c qa
}

oc() {
	export OPENCODE_DISABLE_LSP_DOWNLOAD=true
	export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
	export OPENCODE_EXPERIMENTAL_MARKDOWN=true

	# For LSP servers
	export PATH="\$HOME/.local/share/nvim/mason/bin:\$PATH"

	# For Gemini
	GOOGLE_VERTEX_PROJECT=\$(gcloud config get project)
	export GOOGLE_VERTEX_PROJECT
	export GOOGLE_VERTEX_LOCATION=global
	export VERTEX_LOCATION=global

	# For google-docs MCP
  export GOOGLE_DOCS_MCP_CLIENT_ID="$OC_GOOGLE_DOCS_MCP_CLIENT_ID"
  export GOOGLE_DOCS_MCP_CLIENT_SECRET="$OC_GOOGLE_DOCS_MCP_CLIENT_SECRET"

	# For grafana MCP:
  export GRAFANA_URL="$OC_GRAFANA_URL"
  export GRAFANA_SERVICE_ACCOUNT_TOKEN="$OC_GRAFANA_SERVICE_ACCOUNT_TOKEN"

	opencode "\$@"
}

alias __devenv='source devenv && make environment && make environments-env'

alias c=chezmoi
alias cst='chezmoi status'

alias g=git
alias gcl='git clone --recurse-submodules'
alias gfl='git fetch --prune origin && git pull origin \$(git branch --show-current)'
alias gst='git status --short --untracked-files=all'

alias l1='ls --oneline'
alias l='ls --long --icons=always --header'
alias lk='l --total-size --sort=size --reverse'
alias lr='l --tree --level=2'
alias ls='eza --group-directories-first --color=always --git --all'

alias v=nvim
alias vi=nvim
alias vim=nvim
alias vserve='nvim --headless --listen 127.0.0.1:45678'

alias k=kubecolor
alias rm='rm -i'
alias where=which
EOF
}

__configure-zsh() {
	rm -rf ~/.zim

	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

	zsh -ic 'zimfw build && zimfw compile'
}

__configure-chezmoi() {
	rm -rf ~/.local/share/chezmoi

	chezmoi init \
		github.com/ethan605 \
		--promptString machine_id=devpod \
		--promptString personal_gpg_id=not_applicable \
		--apply \
		--force

	git config --global user.email "$WORK_EMAIL" &&
		git config --global core.excludesfile ~/.gitignore_global
}

__configure-nvim() {
	nvim --headless \
		-c 'Lazy! sync' \
		-c MasonUpdate \
		-c MasonLockRestore \
		-c qa
}

__install-system-packages &&
	__configure-bash &&
	__configure-zsh &&
	__configure-chezmoi &&
	__configure-nvim
