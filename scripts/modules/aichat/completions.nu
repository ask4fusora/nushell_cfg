def query-aichat-completion-values [flag: string] {
  assert binary exists aichat

  try {
    ^aichat $flag
    | lines
    | parse "{value}"
  } catch {
    []
  }
}

export def "nu-complete aichat model" [] {
  query-aichat-completion-values "--list-models"
}

export def "nu-complete aichat role" [] {
  query-aichat-completion-values "--list-roles"
}

export def "nu-complete aichat session" [] {
  query-aichat-completion-values "--list-sessions"
}

export def "nu-complete aichat agent" [] {
  query-aichat-completion-values "--list-agents"
}

export def "nu-complete aichat rag" [] {
  query-aichat-completion-values "--list-rags"
}

export def "nu-complete aichat macro" [] {
  query-aichat-completion-values "--list-macros"
}
