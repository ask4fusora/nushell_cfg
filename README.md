## Environment variables

These are the variables that will affect the behaviors, defaults of my scripts.

| Name | Type      | Default | Description                                                                                                                                          |
| :--- | :-------- | :------ | :--------------------------------------------------------------------------------------------------------------------------------------------------- |
| CWD  | directory |         | Set the current working directory. My Nushell will prefer `$env.CWD` over `$env.PWD`, and will only fallback to `$env.PWD` if `$env.CWD` is not set. |
