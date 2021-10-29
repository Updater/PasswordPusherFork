require "vault/rails"

SERVICE_ACCOUNT_TOKEN_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/token"

Vault::Rails.configure do |vault|
  # Use Vault in transit mode for encrypting and decrypting data. If
  # disabled, vault-rails will encrypt data in-memory using a similar
  # algorithm to Vault. The in-memory store uses a predictable encryption
  # which is great for development and test, but should _never_ be used in
  # production. Default: ENV["VAULT_RAILS_ENABLED"].
  vault.enabled = Rails.env.production?

  # The name of the application. All encrypted keys in Vault will be
  # prefixed with this application name. If you change the name of the
  # application, you will need to migrate the encrypted data to the new
  # key namespace. `vault-rails` uses ENV["VAULT_RAILS_APPLICATION"] if
  # not set here.
  vault.application = SERVICE_NAME

  vault.address = ENV["VAULT_ADDR"]
end

if File.exist?(SERVICE_ACCOUNT_TOKEN_PATH)
  role = ENV["VAULT_ROLE"] || SERVICE_NAME
  json = Vault.post(
    "/v1/auth/kubernetes/login",
    JSON.fast_generate({role: role, jwt: File.read(SERVICE_ACCOUNT_TOKEN_PATH)})
  )

  secret = Secret.decode(json)
  Vault.token = secret.auth.client_token
else
  Vault.token = ENV["VAULT_TOKEN"]
end

$VAULT_TOKEN_DATA = Vault.auth_token.lookup_self().data
