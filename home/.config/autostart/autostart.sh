runOnce(){
    for cmd in "$@"
    do
        pgrep -u $USER -fx '$cmd' > /dev/null || $cmd &
    done
}

runOnce picom fcitx5 nm-applet pasystray

pgrep 'firefox' || firefox &