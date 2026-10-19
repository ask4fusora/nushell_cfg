module aichat {
    use modules/assert *

    export def generate-commit []: nothing -> string {
        assert binary exists git
        assert binary exists aichat

        let diff = ^git --no-pager diff -pBMC --staged
        let prompt = (
            [
                'The following is the diff, write commit message',
                $diff
            ]
            | str join (char nl)
        )

        ^aichat -c $prompt
    }
}

export use aichat
