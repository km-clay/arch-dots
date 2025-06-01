echo "Moving to $HOME and cloning dotfiles repo"
if ! command -v git &> /dev/null; then
	echo "You don't have git"
	exit 1
fi

cd "$HOME"
if [ -e ./dotfiles]; then
	echo "./dotfiles already exists, exiting..."
	exit 1
fi
mkdir -p ./.config

git clone "https://github.com/km-clay/arch-dots" ./dotfiles
cd dotfiles
mkdir -p backup

if [[ ! -e ./config || ! -d ./config ]]; then
	echo "./config does not exist, or is not a directory. exiting"
	exit 1
fi

if [[ ! -e ./pacmanifest.txt ]]; then
	echo "./pacmanifest.txt does not exist. exiting"
	exit 1
fi

if ! which yay &> /dev/null; then
	echo "Installing yay..."
	(sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si); [ -d yay ] && rm -rfv yay
	echo "done"
fi

echo "Installing Rust..."
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"

		# Set toolchain, install components
		rustup install nightly && \
		rustup default nightly && \
		rustup component add clippy --toolchain nightly && \
		rustup component add rust-analyzer --toolchain nightly
else
    echo "Rust is already installed"
fi

# Ensure env is loaded even in a non-login shell
export PATH="$HOME/.cargo/bin:$PATH"

echo "installing packages..."
xargs -a pacmanifest.txt yay -S --needed --noconfirm --nodiffmenu --nocleanmenu --removemake
echo "done"

echo "The files in ./config are about to be symlinked to ~/.config"
echo "This script will perform the following following destructive operations:"
for file in ./config/*; do
	config_dir_pretty="\e[35m~/.config/\e[36m$(basename $file)\e[0m"
	config_dir="$HOME/.config/$(basename $file)"
	if [ "$(basename $file)" = "zsh" ]; then
		if [ -e "$HOME/.zshrc" ]; then
			if [ -L "$HOME/.zshrc" ]; then
				echo -e "\e[31mRemove\e[0m the existing symlink at \e[35m~/.zshrc\e[0m"
			else
				echo -e "\e[35mMove\e[0m \e[35m~/.zshrc\e[0m to \e[36m./backup\e[0m"
			fi
		fi
	elif [ "$(basename $file)" = "fern" ]; then
		if [ -e "$HOME/.fernrc" ]; then
			if [ -L "$HOME/.fernrc" ]; then
				echo -e "\e[31mRemove\e[0m the existing symlink at \e[35m~/.fernrc\e[0m"
			else
				echo -e "\e[35mMove\e[0m \e[35m~/.fernrc\e[0m to \e[36m./backup\e[0m"
			fi
		fi
	elif [ -e "$config_dir" ]; then
		if [ -L "$config_dir" ]; then
			echo -e "\e[31mRemove\e[0m the existing symlink at $config_dir_pretty"
		else
			echo -e "\e[35mMove\e[0m $config_dir_pretty to \e[36m./backup\e[0m"
		fi
	fi
done
echo
echo -en "continue? \e[32my\e[0m/\e[31mn\e[0m "

while read -r answer; do
	case "$answer" in 
		y)
			break
			;;
		n)
			echo "exiting..."
			exit 0
			;;
		*)
			echo -en "continue? \e[32my\e[0m/\e[31mn\e[0m "
			;;
	esac
done

for file in ./config/*; do
	config_dir="$HOME/.config/$(basename $file)"
	if [[ "$(basename $file)" = "zsh" ]]; then
		if [[ -e "$HOME/.zshrc" ]]; then
			if [[ -L "$HOME/.zshrc" ]]; then
				echo -e "\e[31mremoving\e[0m old symlink at \e[36m$HOME/.zshrc\e[0m"
				rm "$HOME/.zshrc"
			else 
				echo -e "\e[35mmoving\e[0m \e[36m$HOME/.zshrc\e[0m to \e[36m./backup\e[0m"
				mv "$HOME/.zshrc" ./backup
			fi
		fi
		echo -e "symlinking \e[36m$(realpath "$file")/zshrc\e[0m to \e[36m$HOME/.zshrc\e[0m"
		echo -e "\e[35mupdating\e[0m zsh src directory to \e[36m$(realpath "$file")/src\e[0m"
		sed -i "s#^export ZSH_SOURCE=\".*\"\$#export ZSH_SOURCE=\"$(realpath "$file")/src\"#" "$file/zshrc"
		ln -s "$(realpath "$file")/zshrc" "$HOME/.zshrc"
		continue
	elif [[ "$(basename $file)" = "fern" ]]; then
		if [[ -e "$HOME/.fernrc" ]]; then
			if [[ -L "$HOME/.fernrc" ]]; then
				echo -e "\e[31mremoving\e[0m old symlink at \e[36m$HOME/.fernrc\e[0m"
				rm "$HOME/.fernrc"
			else 
				echo -e "\e[35mmoving\e[0m \e[36m$HOME/.fernrc\e[0m to \e[36m./backup\e[0m"
				mv "$HOME/.fernrc" ./backup
			fi
		fi
		echo -e "symlinking \e[36m$(realpath "$file")/fernrc\e[0m to \e[36m$HOME/.fernrc\e[0m"
		echo -e "\e[35mupdating\e[0m zsh src directory to \e[36m$(realpath "$file")/src\e[0m"
		sed -i "s#^src_folder=\".*\"\$#src_folder=\"$(realpath "$file")/src\"#" "$file/fernrc"
		ln -s "$(realpath "$file")/fernrc" "$HOME/.fernrc"
		continue
	elif [[ -e "$config_dir" ]]; then
		if [[ -L "$config_dir" ]]; then
			echo -e "\e[31mremoving\e[0m old symlink at \e[36m$config_dir\e[0m"
			rm "$config_dir"
		else 
			echo -e "\e[35mmoving\e[0m \e[36m$config_dir\e[0m to \e[36m./backup\e[0m"
			mv "$config_dir" ./backup
		fi
	fi
	echo -e "symlinking \e[36m$(realpath "$file")\e[0m to \e[36m$config_dir\e[0m"
	ln -s "$(realpath "$file")" "$config_dir"
done


echo "Installing oh-my-zsh"
KEEP_ZSHRC=yes CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZSH="$HOME/.oh-my-zsh"
PLUGINS="$ZSH/custom/plugins"
echo "Installing oh-my-zsh plugins"
mkdir -p "$PLUGINS"
git clone "https://github.com/zsh-users/zsh-autosuggestions" "$PLUGINS/zsh-autosuggestions"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting" "$PLUGINS/zsh-syntax-highlighting"
git clone "https://github.com/Aloxaf/fzf-tab" "$PLUGINS/fzf-tab"
git clone "https://github.com/km-clay/cmdstat" "$PLUGINS/cmdstat"
(cd "$PLUGINS"/cmdstat && cargo build --release && install -Dm755 target/release/cmdstat ~/.local/bin/)

cd $HOME/dotfiles
echo -en "Do you want to make a new branch for this machine? \e[32my\e[0m/\e[31mn\e[0m "

while read -r answer; do
	case "$answer" in
		y)
			echo -n "Name it: "
			read -r name
			git checkout -b "$name"
			break
			;;
		n)
			break
			;;
		*)
			echo -en "Do you want to make a new branch for this machine? \e[32my\e[0m/\e[31mn\e[0m "
			;;
	esac
done

chsh -s $(which zsh)

echo
echo "That's all folks"
echo "You may need to alter the monitor configurations in config/hypr/hyprland.conf and config/waybar/{stylehor.css,config_horizontal}
exit 0
