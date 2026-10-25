## Environment variables

These are the environment variables that will affect the behaviors and defaults of my scripts.

| Name   | Type        | Default | Description                                                                                                                                                                                                                                                                 |
| :----- | :---------- | :------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| MY_CWD | `directory` |         | Set the current working directory. My Nushell will prefer `$env.MY_CWD` over `$env.PWD`, and will only fallback to `$env.PWD` if `$env.MY_CWD` is not set. This variable when set will automatically be path-expanded, if the provided path does not exist, throw an error. |
