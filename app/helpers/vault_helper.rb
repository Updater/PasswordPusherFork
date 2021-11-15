module VaultHelper
  def valid_vault_token?
    current_time = Time.now

    return false unless unexpired_token?(current_time)

    if token_expires_in_less_than_half_of_ttl?(current_time)
      return renew_vault_token!()
    else
      return true
    end
  end

  def cached_vault_token_expire_time
    Time.parse($VAULT_TOKEN_DATA[:expire_time])
  end

  def cached_vault_token_id
    $VAULT_TOKEN_DATA[:id]
  end

  def cached_vault_token_ttl
    $VAULT_TOKEN_DATA[:ttl]
  end

  def cached_vault_token_time_remaining(current_time)
    cached_vault_token_expire_time() - current_time
  end

  def unexpired_token?(current_time)
    Vault.token == cached_vault_token_id() && current_time < cached_vault_token_expire_time()
  end

  def token_expires_in_less_than_half_of_ttl?(current_time)
    cached_vault_token_time_remaining(current_time) < (cached_vault_token_ttl() / 2)
  end

  def renew_vault_token!
    begin
      Vault.auth_token.renew_self()
      $VAULT_TOKEN_DATA = Vault.auth_token.lookup_self().data
      return true
    rescue Vault::HTTPClientError => error
      logger.error(error)
      return false
    end
  end
end
