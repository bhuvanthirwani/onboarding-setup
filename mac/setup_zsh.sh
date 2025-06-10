#!/bin/bash

echo "🔄 Cleaning up old Zsh configuration..."

# Remove previous Zsh config
rm -f ~/.zshrc ~/.zsh_aliases ~/.zprofile ~/.zlogin ~/.zshenv
rm -rf ~/.zsh ~/.oh-my-zsh

echo "✅ Old Zsh config removed."

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew is already installed."
fi

echo "⚙️ Installing Oh My Zsh..."

export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ensure ZSH_CUSTOM is defined
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "🎨 Installing Powerlevel10k theme..."

# Install Powerlevel10k theme in the correct directory
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "$ZSH_CUSTOM/themes/powerlevel10k"

echo "🔤 Installing MesloLGS NF font..."

brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

echo "📁 Creating alias file..."

cat <<'EOF' > ~/.zsh_aliases
# === General Aliases ===
alias p3='python3'
alias py='python3'
alias pip3='pip3 install'
alias ..='cd ..'
alias ...='cd ../..'
alias clr='clear'
alias ll='ls -lah'
alias sz='source ~/.zshrc'

# === Git / GitHub Aliases ===
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gcl='git clone'
alias gcam='git commit -am'
alias gl='git log --oneline --graph --all'

# === Kubernetes Aliases ===
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# === Cursor CLI Aliases ===
alias cur='cursor'
alias curr='cursor run'
alias curc='cursor create'
alias curh='cursor help'

# === Docker Aliases ===
alias d='docker'
alias dps='docker ps'
alias di='docker images'
alias db='docker build . -t'
alias dr='docker run -it'
alias dstop='docker stop $(docker ps -q)'

# === Terraform Aliases ===
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
EOF

echo "📝 Creating .zshrc with Powerlevel10k..."

cat <<EOF > ~/.zshrc
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source \$ZSH/oh-my-zsh.sh

# Load custom aliases
if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi
EOF

echo "🧬 Setting Zsh as default login shell..."
chsh -s /bin/zsh

echo "✅ Setup complete!"
echo "📌 Please set your terminal font to 'MesloLGS NF' for proper Powerlevel10k display:"
echo "   Terminal > Preferences > Profiles > Text > Font > Select 'MesloLGS NF'"
echo ""
echo "🔁 Run: exec zsh"
echo "✨ Powerlevel10k will launch its configuration wizard on first launch."
