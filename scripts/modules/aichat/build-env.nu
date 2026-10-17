use env.nu *
use keybindings.nu *

export def --env "aichat build-env" [] {
  assert binary exists aichat

  install-aichat-env

  install-aichat-keybindings
}
