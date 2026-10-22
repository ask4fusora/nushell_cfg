module main {
    use modules/assert *

    # Pipe in and out of a text editor.
    #
    # The editor is chosen with the following sequence:
    # - Value of `--editor(-e)` flag.
    # - Value of `$env.config.buffer_editor`.
    # - Value of `$env.EDITOR`.
    # - Abort if does not find any.
    export def vipe [--editor(-e): oneof<string, nothing>]: string -> string, nothing -> string {
        if (
            ($editor | describe) == 'string'
            and ($editor | str trim | is-empty)
        ) {
            error make {
                msg: 'Incorrect parameter.'
                labels: [
                    {
                        text: 'Must not be an empty string.'
                        span: (metadata $editor).span
                    }
                ]
            }
        }

        let editor_argv = (
            (if $editor == null { null } else { $editor | split row -r '\s+' })
            | default --empty $env.config.buffer_editor?
            | default --empty ([$env.EDITOR?] | compact --empty)
            | default --empty null
        )
        if $editor_argv == null {
            error make --unspanned {
                msg: 'No editor is configured.'
                help: 'Provide an editor with `--editor`, or by configuring either `$env.config.buffer_editor` or `EDITOR`.'
            }
        }

        assert binary exists $editor_argv.0

        let stdin = $in | default ""
        let temp_file = mktemp -t 'vipe.XXXXX'

        try {
            $stdin | save --force $temp_file
            run-external ...([$editor_argv] | flatten) $temp_file
            open --raw $temp_file | collect | str trim
        } catch {|err| error make $err } finally {
            rm --force --permanent $temp_file
        }
    }
}

export use main *
