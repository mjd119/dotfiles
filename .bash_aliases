# Added aliases (mjd119)
alias mstart='sudo systemctl restart mpd mpdscribble'
alias mstop='sudo systemctl stop mpd mpdscribble'
alias mstatus='sudo systemctl status mpd mpdscribble'
alias ls="exa --group-directories-first -gh"
alias grep='grep --color=auto'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias trim="awk '!/^ *#/ && NF'" #(https://stackoverflow.com/a/17396799)
alias startfolding="systemctl start foldingathome"
alias stopfolding="systemctl stop foldingathome"
alias statusfolding="systemctl status foldingathome"
alias startkde="startx /usr/bin/startplasma-x11"
alias gulp="i3-swallow"
alias sgulp="sudo i3-swallow"
alias xdocker="docker run --rm -it --name my-running-app -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro"
alias music="tmux new-session 'tmux source-file ~/.config/ncmpcpp/tmux_session'"
alias peekrtorrent="sudo -u rtorrent tmux a -t rtorrent"
