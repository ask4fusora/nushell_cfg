module aichat {
    use modules/assert *
    use modules/complete *
    use modules/agent-skills *

    export const generate_commit_skill_name_env_key = 'AICHAT_GENERATE_COMMIT_SKILL_NAME'

    def build-agent-skill-prompt [skill_name: oneof<string, nothing>]: nothing -> oneof<string, nothing> {
        let skill_name = $skill_name | default ($env | get -o $generate_commit_skill_name_env_key)
        if $skill_name == null { return }

        let skill_file_path = agent-skills file-path $skill_name
        if $skill_file_path == null { return }

        let skill = open -r $skill_file_path | from agent-skill
        if ($skill.content | is-empty) { return }

        [
            'The user has selected the following skill for writing commit message that you should follow:'
            $'<skill_content name="($skill.name)">'
            $skill.content
            '</skill_content>'
        ]
        | str join (char nl)
    }

    export def generate-commit [--agent-skill-name(-s): oneof<string, nothing>]: nothing -> string {
        assert binary exists git
        assert binary exists aichat

        let out = ^git --no-pager diff -pM --staged | complete
        if $out.exit_code != 0 {
            error make --unspanned (
                $out.stderr
                | default $out.stdout
                | default 'Unknown error occured.'
                | str trim
            )
        }

        let diff = $out.stdout
        let prompt = (
            [
                'Write a concise commit message.',
                ($agent_skill_name | build-agent-skill-prompt $in),
                'Here are the changes in this commit (`git diff --staged`):',
                '<diff>',
                ($diff | str trim)
                '</diff>',
            ]
            | compact
            | str join (char nl)
        )

        ^aichat -c $prompt | complete | complete unwrap
    }
}

export use aichat
