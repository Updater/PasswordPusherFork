class OpsController < ActionController::API
  include VaultHelper

  def livez
    if valid_vault_token?
      render plain: "OK"
    else
      render status: 500, plain: "Internal Server Error"
    end

  end

  def readyz
    render plain: "OK"
  end

  def versionz
    render plain: ENV["VERSION"]
  end
end
