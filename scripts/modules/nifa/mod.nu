module extern {
    use modules/assert *
    use modules/complete *

    const nifa_commands_supporting_format_flag = [
        if
        addr
        link
        route
        neigh
        sock
        sys
    ]

    export def --wrapped nifa [...args: string]: nothing -> any {
        assert binary exists nifa

        let has_format_flag = $args | any {|arg| $arg =~ '^--format(=|$)' }
        let is_invoking_help = $args | any {|arg| $arg == '--help' or $arg == 'help' }
        let is_invoking_command_supporting_format_flag = (
            0..2
            | each {|i| $args | get -o $i }
            | compact -e
            | any { $in in $nifa_commands_supporting_format_flag }
        )

        if (
            $is_invoking_command_supporting_format_flag
            and not $has_format_flag
            and not $is_invoking_help
        ) {
            ^nifa ...($args | append '--format=json')
            | complete
            | complete unwrap
            | from json
        } else {
            ^nifa ...$args | complete | complete unwrap
        }
    }
}

export use extern *
