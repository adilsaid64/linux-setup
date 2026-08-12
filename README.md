# linux-setup

Bootstrap script for a terminal setup I actually like: **Oh My Zsh**, **Powerlevel10k**, and **tmux**.

## What it installs

- `zsh`, `tmux`, `git`, `curl`, `wget`, `unzip`, `fontconfig`
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`
- MesloLGS Nerd Font under `~/.local/share/fonts` (Linux side)
- Symlinks for `.zshrc` and `.tmux.conf`

Supports **apt**, **dnf**, and **pacman**. Safe to re-run.

## Quick start

```bash
git clone https://github.com/adilsaid64/linux-setup.git
cd linux-setup
chmod +x install.sh
./install.sh
```

Then:

1. Install **MesloLGS NF** on Windows (see below) and set it as your terminal / Cursor font
2. Restart the terminal (or `exec zsh`)
3. Run `p10k configure`

## Windows font (WSL)

On WSL, Windows Terminal / Cursor need the font installed on **Windows**. Download and double-click each file → **Install**:

- [MesloLGS NF Regular](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
- [MesloLGS NF Bold](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
- [MesloLGS NF Italic](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
- [MesloLGS NF Bold Italic](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

Then set the font face to **MesloLGS NF** in Windows Terminal / Cursor.

## Layout

```
linux-setup/
├── install.sh
├── configs/
│   ├── .tmux.conf
│   └── .zshrc
└── README.md
```

Existing `.zshrc` / `.tmux.conf` files are backed up to `*.backup` before being replaced with symlinks.
