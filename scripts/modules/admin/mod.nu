export def elevate [] {
  assert binary exists sudo

  ^sudo nu
}

export def --wrapped sudo [...args] {
  assert binary exists sudo

  let command = $args | str join ' '

  ^sudo nu -c $command
}
