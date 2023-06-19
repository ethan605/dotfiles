SHELL = /bin/zsh
.PHONY: all clean brew terminfo

all: brew nvim nvim-packer terminfo tmux tmux-tpm zim

brew:
	/usr/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/brew.sh \
		&& /bin/bash /tmp/brew.sh \
		&& echo 'export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$$PATH"' > ~/.zshrc \
		&& source ~/.zshrc \
		&& /usr/bin/curl https://raw.githubusercontent.com/ethan605/dotfiles/main/dot_Brewfile -o ~/.Brewfile \
		&& brew bundle --global

nvim: nvim-packer

nvim-packer:
	git clone --depth 1 https://github.com/wbthomason/packer.nvim \
		~/.local/share/nvim/site/pack/packer/start/packer.nvim

terminfo:
	export PATH="$$(brew --prefix ncurses)/bin:$$PATH" \
		&& infocmp -x tmux-256color > /tmp/tmux-256color.src \
		&& /usr/bin/tic -x /tmp/tmux-256color.src

tmux: tmux-tpm

tmux-tpm:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

zim:
	/usr/bin/curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
