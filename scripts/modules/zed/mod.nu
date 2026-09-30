module completions {
    def "nu-complete zed completions" [] {
        require-executable zed

        [
            "bash"
            "elvish"
            "fish"
            "nushell"
            "powershell"
            "zsh"
        ]
    }

    export extern zed [
        --wait(-w)                # Wait for all of the given paths to be opened/closed before exiting
        --add(-a)                 # Add files to the currently open workspace
        --new(-n)                 # Create a new workspace
        --reuse(-r)               # Reuse an existing window, replacing its workspace
        --existing(-e)            # Open in existing Zed window
        --classic                 # Use the classic open behavior: new window for directories, reuse for files
        --user-data-dir: path     # Sets a custom directory for all user data (e.g., database, extensions, logs). This overrides the default platform-specific data directory location: `%LOCALAPPDATA%\Zed`
        --version(-v)             # Print Zed's version and the app path
        --foreground              # Run zed in the foreground (useful for debugging)
        --zed: path               # Custom path to Zed.app or the zed binary
        --dev-server-token: string # Run zed in dev-server mode
        --wsl: string             # The username and WSL distribution to use when opening paths. If not specified, Zed will attempt to open the paths directly
        --system-specs            # Not supported in Zed CLI, only supported on Zed binary Will attempt to give the correct command to run
        --dev-container           # Open the project in a dev container
        --diff: path              # Pairs of file paths to diff. Can be specified multiple times. When directories are provided, recurses into them and shows all changed files in a single multi-diff view
        --completions: string@"nu-complete zed completions" # Generate shell completions for Zed
        --askpass: string         # Used for SSH/Git password authentication, to remove the need for netcat as a dependency, by having Zed act like netcat communicating over a Unix socket
        --help(-h)                # Print help (see more with '--help')
        ...paths_with_position: path # The paths to open in Zed (space-separated)
    ]
}

export-env {
    if $env.EDITOR? == "zed -w" or $env.EDITOR? == "zed --wait" {
        $env.config.buffer_editor = ["zed" "-w"]
    }
}

export use completions *
