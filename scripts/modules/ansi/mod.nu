const ansi_reset = ansi reset
const ansi_codes = ansi -l | get name

module ext {
    def "nu-complete style" [] {
        $ansi_codes
    }

    export def style [style: string@"nu-complete style"]: string -> string {
        $'(ansi $style)($in)($ansi_reset)'
    }
}

export use ext *
