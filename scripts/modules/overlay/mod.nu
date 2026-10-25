# The `diroverlay:` overlay-name prefix is reserved in order for this module to work.
# To use an overlay, is to use a module. Specifically, this module is wildcard
# imported. This is equivalent to `use overlay.nu *`.

module overlay {
    module diroverlay {
        use modules/path *

        const overlay_name_prefix = 'diroverlay:'
        const overlay_file_name = 'overlay.nu'
        const hook_annotation = 'is_diroverlay_hook'

        export def "to hook" []: oneof<string, closure> -> record {
            {code: $in} | insert $hook_annotation true
        }

        export def is-diroverlay []: record<name: string, active: bool> -> bool {
            $in | get name | str starts-with $overlay_name_prefix
        }

        export def files []: string -> list<string> {
            path ancestors | each { path join $overlay_file_name } | where { path exists }
        }

        export def name []: string -> string {
            $overlay_name_prefix + $in
        }

        export def cleanup-hook []: nothing -> record {
            {
                $env.config.hooks.pre_prompt = (
                    $env.config.hooks.pre_prompt
                    | where {|hook|
                        if (
                            ($hook | describe -d).type == 'record'
                            and ($hook | get -o $hook_annotation) == true
                        ) { return false }

                        return true
                    }
                )
            }
            | to hook
        }
    }

    use diroverlay

    export def --env sync [cwd?: directory, --reload(-r)]: nothing -> nothing {
        if $cwd != null and not ($cwd | path exists) {
            error make {
                msg: 'Incorrect argument.'
                labels: [
                    {
                        span: (metadata $cwd).span
                        text: $'`($cwd)` is a non-existent path.'
                    }
                ]
                help: 'Make sure the provided path exists.'
            }
        }

        let diroverlay_root = (
            $cwd
            | default $env.MY_CWD?
            | default $env.PWD
        )
        let active_diroverlays = (
            overlay list
            | where active
            | where ($it | diroverlay is-diroverlay)
        )
        let diroverlays_to_ensure_activated = (
            $diroverlay_root
            | diroverlay files
            | zip $in
            | into record
            | transpose file name
            | update name { diroverlay name }
        )
        let diroverlay_names_to_hide = (
            $active_diroverlays
            | get name
            | difference $diroverlays_to_ensure_activated.name
        )
        let overlay_hide_hooks = (
            $diroverlay_names_to_hide
            | each {
                $"overlay hide --keep-env=[PWD] '($in)'" | diroverlay to hook
            }
        )
        let overlay_use_hooks = (
            $diroverlays_to_ensure_activated
            | if $reload { $in } else {
                where name not-in $active_diroverlays.name
            }
            | each {
                $"overlay use --reload=($reload) '($in.file)' as '($in.name)'"
                | diroverlay to hook
            }
        )

        $env.config.hooks.pre_prompt = (
            $env.config.hooks.pre_prompt
            | append (diroverlay cleanup-hook)
            | append $overlay_hide_hooks
            | append $overlay_use_hooks
        )
    }
}

export use overlay

export-env {
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD?
        | default []
        | append {|_, cwd| overlay sync $cwd }
    )
}
