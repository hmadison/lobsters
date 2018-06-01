Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    user = User.find_by(session_token: session[:u])

    if user && user.is_active?
      user
    else
      redirect_to(login_url)
    end
  end

  admin_authenticator do
    user = User.find_by(session_token: session[:u])

    if user && user.is_admin?
      user
    else
      redirect_to(login_url)
    end
  end

  realm Rails.application.name.gsub(' ', '')

  default_scopes :public
end
