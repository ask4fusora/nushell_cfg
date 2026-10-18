def build-aichat-keybindings [] {
  [
    {
      name: aichat_integration
      modifier: alt
      keycode: char_l
      mode: [emacs, vi_insert]
      event: [
        {send: executehostcommand, cmd: "let commandline_text = (commandline); if ($commandline_text | str trim) != '' { if (is-terminal --stdout) { print ' - ...' }; commandline edit -r (aichat -e $commandline_text) }"}
      ]
    }
  ]
}

def with-aichat-keybindings [] {
  let config = $env.config? | default {} | upsert keybindings { default [] }

  let installed = ($config.keybindings | any {|binding|
    ($binding.name? | default "") == "aichat_integration"
  })

  if $installed {
    $config
  } else {
    $config | upsert keybindings ($config.keybindings ++ (build-aichat-keybindings))
  }
}

export def --env install-aichat-keybindings [] {
  $env.config = (with-aichat-keybindings)
}
