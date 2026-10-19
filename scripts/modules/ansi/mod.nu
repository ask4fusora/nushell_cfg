module ext {
    const ansi_reset = ansi reset
    const ansi_codes = ansi -l | get name

    def "nu-complete style" [] {
        $ansi_codes
    }

    export def style [style: string@"nu-complete style"]: string -> string {
        $'(ansi $style)($in)($ansi_reset)'
    }

    export def apply [ansi_esc_seq: string]: string -> string {
        $'($ansi_esc_seq)($in)($ansi_reset)'
    }
}

export use ext *
