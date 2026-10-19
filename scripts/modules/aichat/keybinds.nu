module keybinds {
    export def --env init [] {
        $env.config.keybindings ++= [
            {
                name: aichat_integration
                modifier: alt
                keycode: char_l
                mode: [vi_insert]
                event: [
                    {
                        send: ExecuteHostCommand
                        cmd: (
                            [
                                'use modules/assert *'
                                'assert binary exists aichat'
                                'let commandline_text = commandline'
                                'if ($commandline_text | str trim) != "" {'
                                '   print " - ..."'
                                '   commandline edit -r (^aichat -e $commandline_text)'
                                '}'
                            ]
                            | str join (char nl)
                        )
                    }
                ]
            }
        ]
    }
}

export use keybinds
