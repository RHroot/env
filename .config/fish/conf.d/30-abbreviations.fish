# Navigation
abbr -a d "z"
abbr -a pd "cd -"
abbr -a c "clear"
abbr -a home "cd ~"
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."
abbr -a ..... "cd ../../../.."

# Editors
abbr -a v "vim"
abbr -a sv "sudo vim"
abbr -a n "nvim"
abbr -a sn "sudo nvim"

# Tmux
abbr -a tns "tmux new -s"
abbr -a ta "tmux attach"
abbr -a td "tmux detach"

# System helpers
abbr -a psa "ps auxf"
abbr -a fdh "fd --hidden"
abbr -a pgrep "ps aux | rg"
abbr -a hg "history | rg"
abbr -a openports "netstat -tulanp"
abbr -a fda "fd --absolute-path"
abbr -a fdah "fd --absolute-path --hidden"

# System control
abbr -a reboot "systemctl reboot"
abbr -a shutnow "shutdown now"
abbr -a logout "loginctl kill-session $XDG_SESSION_ID"
abbr -a restart-dm "sudo systemctl restart display-manager"

# File operations
abbr -a rm "rm -iv"
abbr -a cp "cp -iv"
abbr -a cpr "cp -riv"
abbr -a scp "sudo cp -iv"
abbr -a scpr "sudo cp -riv"
abbr -a rmd "rm -rfv"
abbr -a mkdir "mkdir -pv"

# Disk usage
abbr -a diskspace "du -S | sort -n -r | less"
abbr -a folders "du -h --max-depth=1"
abbr -a mountedinfo "df -hT"
abbr -a duf "duf -hide special"

# Permissions & security
abbr -a sha1 "openssl sha1"
abbr -a own "sudo chown -R $USER"

# Dev & tools
abbr -a grep "grep --color=auto"
abbr -a rg "rg --color=auto"
abbr -a myip "curl ifconfig.me"
abbr -a bright "brightnessctl set"
abbr -a oc "opencode --port 3000"
abbr -a ga "git add"
abbr -a gp "git push"
abbr -a gd "git diff"
abbr -a gs "git status"

# Utilities
abbr -a kssh "kitty +kitten ssh"
abbr -a web "cd /var/www/html"
abbr -a da 'date "+%Y-%m-%d %A %T %Z"'
abbr -a ai 'ollama run llama3-local'
abbr -a aria2-down 'aria2c --conf-path=$HOME/.config/aria2/aria2.conf'

# System Information
abbr -a fetch "fastfetch -c my.jsonc"
abbr -a open "xdg-open"
abbr -a vol "wpctl get-volume @DEFAULT_AUDIO_SINK@"

# LS commands
abbr -a la "ls -A --hyperlink=auto"
abbr -a lz "ls -lhAi --hyperlink=auto"
abbr -a lh "ls -d .* 2>/dev/null --hyperlink=auto"
abbr -a tree "tree -a 2>/dev/null || ls -R"
