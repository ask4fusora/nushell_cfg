use build-env.nu *

export-env {
  require-executable zoxide

  zoxide build-env
}

export def --env --wrapped z [...rest: directory] {
  require-executable zoxide

  let path = match $rest {
    [] => { "~" }
    ["-"] => { "-" }
    [$arg] => {
      if (try {
        $arg | path expand | path type
      } catch { null }) == "dir" { $arg } else {
        ^zoxide query --exclude $env.PWD -- $arg | str trim -r -c "\n"
      }
    }
    _ => {
      ^zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n"
    }
  }

  cd $path
}

export def --env --wrapped zi [...rest: directory] {
  require-executable zoxide

  cd $'(^zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
}
