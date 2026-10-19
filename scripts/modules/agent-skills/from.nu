module from {
    export def agent-skill []: string -> record {
        let skill = (
            $in
            | parse --regex '(?ms)\A\x{FEFF}?---[ \t]*\r?\n(?<frontmatter>.*?)^---[ \t]*(?:\r?\n|\z)(?<content>.*)\z'
            | get -o 0
        )

        if $skill == null {
            error make --unspanned {msg: 'Expected YAML frontmatter enclosed by --- lines.'}
        }

        let frontmatter = $skill.frontmatter | from yaml
        let content = $skill.content | str trim

        $frontmatter | upsert content $content
    }
}

export use from
