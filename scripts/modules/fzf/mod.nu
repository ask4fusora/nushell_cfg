export-env {
    require-executable fzf

    $env.FZF_DEFAULT_OPTS = "--style=full"
}

export def pick [
    --multi(-m): oneof<bool, int> = false # Allow multi-selection (`0` for unlimited).
    --padding(-p): int = 1 # Table padding.
]: table -> oneof<table, record> {
    require-executable fzf

    let has_multi_limit = ($multi | describe) == "int"
    if $has_multi_limit and $multi < 0 {
        error make {
            msg: 'Incorrect argument.'
            labels: [
                {
                    text: "Must be either a non-negative number or a boolean."
                    span: (metadata $multi | get span)
                }
            ]
        }
    }

    $env.config.table.padding = $padding

    let pipeline_input = $in

    let selected_indices = $pipeline_input
    | table --theme=none -c
    | lines
    | str trim --left
    | str join (char nl)
    | (
        ^fzf
        --ansi
        --header-lines=1
        --accept-nth='{n}'
        ...(if $multi == true { [--multi] } else if $has_multi_limit { [$'--multi=($multi)'] })
    )
    | lines
    | into int

    let selected_records = $selected_indices | each {|it| $pipeline_input | get $it }

    if $multi {
        return $selected_records
    }

    $selected_records | first
}
