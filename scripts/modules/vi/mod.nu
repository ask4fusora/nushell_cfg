export-env {
    $env.config.edit_mode = "vi"
    $env.config.cursor_shape = {vi_insert: line, vi_normal: block}

    $env.config.keybindings ++= [
        {
            name: open_editor_restore_input
            modifier: control
            keycode: char_o
            mode: [vi_insert vi_normal]
            event: [
                {send: openeditor}
                {send: executehostcommand, cmd: ""}
            ]
        }
    ]
}
