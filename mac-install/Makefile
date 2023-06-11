SHELL = /bin/zsh
.PHONY: all clean brew terminfo

all: brew terminfo zim nvim

brew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/brew.sh \
		&& /bin/bash /tmp/brew.sh \
		&& echo 'export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"' > ~/.zshrc \
		&& curl https://raw.githubusercontent.com/ethan605/dotfiles/main/dot_Brewfile -o ~/.Brewfile \
		&& brew bundle

terminfo:
	/opt/homebrew/Cellar/ncurses/6.4/bin/infocmp -x tmux-256color > /tmp/tmux-256color.src \
		&& /usr/bin/tic -x /tmp/tmux-256color.src

zim:
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

nvim: packer

packer:
	git clone --depth 1 https://github.com/wbthomason/packer.nvim \
		~/.local/share/nvim/site/pack/packer/start/packer.nvim

clean:
	@echo "CLEAN UP..."
