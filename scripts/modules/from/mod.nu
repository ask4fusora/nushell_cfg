module from {
    export def "docker-compose" [] { "[" + $in + "]" | from json }
}

export use from
