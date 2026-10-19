module ansi {
    const ansi_reset = ansi reset
    const ansi_codes = ansi -l | get name

    def "nu-complete style" [] {
        $ansi_codes
    }

    # Style a string with an ansi style.
    @example "Style a red string." { 'red string' | style 'red' }
    export def style [style: string@"nu-complete style"]: string -> string {
        $'(ansi $style)($in)($ansi_reset)'
    }

    # Style a string with an ansi escape sequence.
    @example "Style a red string with an ansi escape sequence." { 'red string' | apply (ansi red) }
    export def apply [ansi_esc_seq: string]: string -> string {
        $'($ansi_esc_seq)($in)($ansi_reset)'
    }
}

export use ansi
