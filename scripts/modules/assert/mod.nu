module assert {
    # Require an external program. Create an error if cannot find any.
    export def "binary exists" [
        program: string # Name of the required program.
    ]: nothing -> nothing {
        if (
            which --all $program
            | where type == external
            | is-empty
        ) {
            error make --unspanned {
                msg: $"Required program `($program)` is unavailable."
                help: $"Install `($program)` or add its directory to `PATH`."
            }
        }
    }
}

export use assert
