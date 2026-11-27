module main {
    use modules/assert *
    use modules/path *

    export def mklink [
        link: path,
        target: path,
        --type(-t): string@[symbolic hard] = symbolic,
        --relocate(-r),
    ]: nothing -> nothing {
        if $type not-in ['symbolic' 'hard'] {
            error make {
                msg: 'Invalid flags.'
                labels: [
                    {
                        text: $'value must be in `([symbolic hard])`.'
                        span: (metadata $type).span
                    }
                ]
            }
        }

        let dest = if $relocate {
            mv $target $link
            { link: $target, target: $link }
        } else {
            { link: $link, target: $target }
        }

        match $nu.os-info.name {
            'windows' => {
                assert binary exists cmd

                let flags = if $type == 'hard' {
                    ['/H']
                } else {
                    let target_probe = if ($dest.target | path is-absolute) {
                        $dest.target
                    } else {
                        $dest.link | path dirname | path join $dest.target
                    }

                    if ($target_probe | path expand | path type) == 'dir' {
                        let is_local_abs = ($dest.target | path is-absolute) and not ($dest.target =~ '^[/\\]{2}')
                        if $is_local_abs { ['/J'] } else { ['/D'] }
                    } else {
                        []
                    }
                }

                let win_link = $dest.link | str replace --all '/' '\'
                let win_target = $dest.target | str replace --all '/' '\'

                ^cmd /c mklink ...$flags $win_link $win_target
            }
            'linux' => {
                assert binary exists ln

                let flag = if $type == 'symbolic' { '-sT' } else { '-T' }
                ^ln $flag -- $dest.target $dest.link
            }
            $os => {
                error make { msg: $'Unsupported operating system: `($os)`.' }
            }
        }
    }
}

export use main *
