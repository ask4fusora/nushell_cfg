export use from.nu *

module agent-skills {
    const dot_agents_folder_name = '.agents'
    const agent_skills_folder_name = 'skills'
    const agent_skill_file_name = 'SKILL.md'

    export def file-path [skill_name: string, --root(-r): oneof<directory, nothing>]: nothing -> oneof<string, nothing> {
        let project_skill_file_path = (
            $root
            | default $env.PWD
            | path join $dot_agents_folder_name $agent_skills_folder_name
            | path join $skill_name
            | path join $agent_skill_file_name
        )
        if ($project_skill_file_path | path exists) {
            return $project_skill_file_path
        }

        let global_skill_file_path = (
            $nu.home-dir
            | path join $dot_agents_folder_name $agent_skills_folder_name
            | path join $skill_name
            | path join $agent_skill_file_name
        )
        if ($global_skill_file_path | path exists) {
            return $global_skill_file_path
        }
    }
}

export use agent-skills
