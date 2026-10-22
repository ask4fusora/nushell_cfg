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

    export def generate-commit [
        --agent-skill-name(-s): oneof<string, nothing>
        --debug-prompt(-d) # Print prompt instead of generating message.
    ]: nothing -> string {
        assert binary exists git
        assert binary exists aichat

        let diff = (
            ^git --no-pager diff -pM --staged --word-diff --no-color
            | complete
            | complete unwrap
        )
        let prompt = (
            [
                'Write a concise commit message.',
                ($agent_skill_name | build-agent-skill-prompt $in),
                'Here are the changes in this commit (`git diff --staged --word-diff`):',
                '<diff>',
                ($diff | str trim)
                '</diff>',
            ]
            | compact
            | str join (char nl)
        )

        if $debug_prompt { $prompt } else {
            ^aichat -c $prompt | complete | complete unwrap
        }
    }
}

export use aichat
