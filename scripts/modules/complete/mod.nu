module complete {
    use modules/ansi *

    # Return an external command's stdout on success, or raise an error on failure.
    @example 'Return stdout on success.' { ^nu --no-config-file -c "print --no-newline hello" | unwrap } --result 'hello'
    @example 'Raise an error using stderr on failure.' { ^nu --no-config-file -c "print --stderr failed; exit 1" | unwrap }
    export def unwrap []: record<exit_code: int, stdout: oneof<string, binary>, stderr: oneof<string, binary>> -> oneof<string, binary> {
        let out = $in

        if $out.exit_code != 0 {
            let stderr = match ($out.stderr | describe) {
                'binary' => { $out.stderr }
                'string' => {
                    $out.stderr | str trim
                }
            }
            let stdout = match ($out.stdout | describe) {
                'binary' => { $out.stdout }
                'string' => {
                    $out.stdout | str trim
                }
            }

            let ansi_int_style = $env.config.color_config.shape_int
            error make --unspanned (
                $stderr
                | default --empty $stdout
                | default --empty $'Unknown error occured. Exit code ($out.exit_code | into string | ansi style $ansi_int_style).'
            )
        }

        $out.stdout
    }
}

export use complete
