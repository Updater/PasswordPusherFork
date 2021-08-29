class CommandsController < ApplicationController

  layout false

  # Rough (& incomplete) list of passwords that should never be used.
  # Feel free to send PRs to add to this list although we'll never be
  # comprehensive here.  We can't save everyone from bad passwords.
  BAD_PASSWORDS = %w[1234 12345 123456 1234567 password
                     qwerty football baseball welcome abc123
                     dragon secret solo princess letmein
                     welcome asdf].freeze

  def create
    if !params.key?(:text) || params[:command] != '/pwpush'
      render plain: "Unknown command: #{params.inspect}"
      return
    end

    secret, opts = params[:text].split(' ')
    if opts
      days, views = opts.split(',')
    end

    if ["help", '-h', 'usage'].include?(secret.downcase)
      render plain: "Usage /pwpush <password> [days,views]"
      return
    end

    if BAD_PASSWORDS.include?(secret.downcase)
      render plain: "Come on...Do you really want to use that password? Put in a bit of effort and try again."
      return
    end

    days ||= EXPIRE_AFTER_DAYS_DEFAULT
    views ||= EXPIRE_AFTER_VIEWS_DEFAULT

    password = Password.new(
      deletable_by_viewer: DELETABLE_BY_VIEWER_PASSWORDS,
      expire_after_days: days,
      expire_after_views: views,
      url_token: rand(36**16).to_s(36),
    )

    password.payload = secret

    password.validate!

    if @password.save
      message = "Pushed password with #{days} days and #{views} views expiration: " +
                "#{request.env["rack.url_scheme"]}://#{request.env['HTTP_HOST']}/p/#{@password.url_token}"
      render plain: message
    else
      render plain: @password.errors
    end
  end
end
