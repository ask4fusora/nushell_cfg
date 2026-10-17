# List git branches. Default to local branches.
export def "gh branches" [
  --remote(-r) # List remote branches.
  --with-origin-prefix # List branch names with `origin/` prefix.
]: nothing -> list<string> {
  assert binary exists git

  mut branches: list<string> = []

  if $remote {
    $branches = ^git branch -r
    | lines
    | find --invert 'origin/HEAD ->'
    | parse --regex '\borigin/(?<branch>.+)'
    | get branch
    | str trim
  } else {
    $branches = ^git branch
    | lines
    | find --invert 'HEAD detached at'
    | parse --regex '\s(?<branch>.+)'
    | get branch
    | str trim
  }

  if $with_origin_prefix {
    let prefixed_branches = $branches | each {|b| $"origin/($b)" }

    return $prefixed_branches
  }

  return $branches
}
