class OpsController < ApplicationController
  layout false

  def livez
    render plain: "OK"
  end

  def readyz
    render plain: "OK"
  end

  def versionz
    render plain: ENV["VERSION"]
  end
end
