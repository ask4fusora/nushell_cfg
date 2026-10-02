export def "sys disks pick-mount" [] {
  require-executable fzf

  let sep = char tab

  sys disks
  | each {|it| $"($it.device)($sep)($it.mount)" }
  | str join (char nl)
  | fzf --delimiter ($sep) --with-nth 1
  | str trim
  | split row (char tab)
  | last
}
