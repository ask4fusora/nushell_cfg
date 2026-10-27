module keybinds {
    use modules/assert *

    export def --env init [] {
        assert binary exists aichat

        $env.config.keybindings ++= [
            {
                name: aichat_integration
                modifier: alt
                keycode: char_l
                mode: [vi_insert]
                event: {
                    send: executehostcommand
                    cmd: (
                            [
                                'use modules/assert *'
                                'assert binary exists aichat'
                                'let commandline_text = commandline'
                                'if ($commandline_text | str trim) != "" {'
                                '   print " - ..." -n'
                                '   commandline edit -r (^aichat -e $commandline_text)'
                                '}'
                            ]
                            | str join (char nl)
                        )
                }
            }
        ]
    }
}

export use keybinds
