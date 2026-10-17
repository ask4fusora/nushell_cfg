export def --wrapped ya [...args] {
  assert binary exists yazi

  ^yazi ...$args
}

export def --env --wrapped y [...args] {
  assert binary exists yazi

  let tmp = (mktemp -t "yazi-cwd.XXXXXX")

  ^yazi ...$args --cwd-file $tmp

  let cwd = (open $tmp)

  if $cwd != $env.PWD and ($cwd | path exists) { cd $cwd }

  rm -fp $tmp
}
