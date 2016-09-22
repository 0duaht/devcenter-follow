class SessionsController < ApplicationController
  def new
  end

  def list
  end

  def failure
    render json: {
      message: 'Failed to authenticate.'
    }, status: 400
  end

  def create
    oauth_user = OauthUser.new(request.env['omniauth.auth'])
    @user = oauth_user.login_or_create
    return start_follow_process if @user

    render json: {
      message: 'Failed. Please try again'
    }, status: 400
  end

  def start_follow_process
    oauth_account = @user.oauth_accounts.find_by(provider: 'github')
    FollowWorker.perform_async oauth_account.id
    render json: {
      message: 'Login Successful. Follow Process initiated'
    }
  end
end
