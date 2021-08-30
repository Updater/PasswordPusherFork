Rails.application.routes.draw do
  root to: "passwords#new"

  resources :c, controller: :commands, as: :commands, allow: %i[create]

  resources :p, controller: :passwords, as: :passwords, except: %i[index edit update] do
    get "preview", on: :member
    get "r", on: :member, as: "preliminary", action: "preliminary"
  end

  get "/pages/*id" => "pages#show", as: :page, format: false
  get "/slack_direct_install", to: redirect("https://slack.com/oauth/authorize?client_id=#{SLACK_CLIENT_ID}&scope=commands", status: 302)

  get "/livez" => "ops#livez"
  get "/readyz" => "ops#readyz"
  get "/versionz" => "ops#versionz"
end
