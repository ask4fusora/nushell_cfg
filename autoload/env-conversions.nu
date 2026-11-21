use modules/env-conversion *

$env.ENV_CONVERSIONS.MY_CWD = {
    from_string: { path expand -s }
}

$env.ENV_CONVERSIONS.MY_TRANSPARENCY_ALPHA = {
    from_string: {
        let $res = $in | into float
        if $res < 0 or $res > 1 {
            error make 'Must be between `0` and `1`.'
        }

        $res
    }
}

$env.ENV_CONVERSIONS.MY_COLOR_MODE = {
    from_string: {
        if $in != 'light' and $in != 'dark' {
            error make 'Must be either `"light"` or `"dark"`.'
        }

        $in
    }
}

$env.ENV_CONVERSIONS.EDITOR = {
    from_string: { split row -r '\s+' }
    to_string: { str join (char space) }
}
