runOnce(){
    for cmd in "$@"
    do
        pgrep -u $USER -fx '$cmd' > /dev/null || $cmd &
    done
}

runOnce picom fcitx5 nm-applet pasystray

pgrep 'firefox' || firefox &

bluetoothctl connect D8:37:3B:66:E2:64