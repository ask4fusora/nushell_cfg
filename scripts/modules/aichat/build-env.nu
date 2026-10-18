use env.nu *
use keybindings.nu *

export def --env "aichat build-env" [] {
  install-aichat-env

  install-aichat-keybindings
}
