
# Environment Variables

For all deployment strategies, the application and it's defaults can be controlled with the following environment variables.

See also `config/environment.rb`.

## Application Defaults

| Variable | Description | Default Value |
| --------- | ------------------ | --- |
| PAYLOAD_INITIAL_TEXT | Overrides the default password input value. | `Enter the Password to be Shared` |
| EXPIRE_AFTER_DAYS_DEFAULT | Controls the "Expire After Days" default value in Password#new | `7` |
| EXPIRE_AFTER_DAYS_MIN | Controls the "Expire After Days" minimum value in Password#new | `1` |
| EXPIRE_AFTER_DAYS_MAX | Controls the "Expire After Days" maximum value in Password#new | `90` |
| EXPIRE_AFTER_VIEWS_DEFAULT | Controls the "Expire After Views" default value in Password#new | `5` |
| EXPIRE_AFTER_VIEWS_MIN | Controls the "Expire After Views" minimum value in Password#new | `1` |
| EXPIRE_AFTER_VIEWS_MAX | Controls the "Expire After Views" maximum value in Password#new | `100` |
| DELETABLE_BY_VIEWER_PASSWORDS | Can passwords be deleted by viewers? When true, passwords will have a link to optionally delete the password being viewed | `false` |
| DELETABLE_BY_VIEWER_DEFAULT | When the above is `true`, this sets the default value for the option. | `true` |
| RETRIEVAL_STEP_ENABLED | When `true`, adds an option to have a preliminary step to retrieve passwords.  | `true` |
| RETRIEVAL_STEP_DEFAULT | Sets the default value for the retrieval step for newly created passwords. | `false` |

## SSL

| Variable | Description |
| --------- | ------------------ |
| FORCE_SSL | The existence of this variable will set `config.force_ssl` to `true` and generate HTTPS based secret URLs
