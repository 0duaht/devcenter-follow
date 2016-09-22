class OauthUser
  attr_reader :auth_data, :provider, :policy, :user

  def initialize(auth_data)
    @auth_data = auth_data
    @provider = auth_data.provider
    @user = nil
    @policy = "#{@provider.capitalize}Policy".constantize.new(auth_data)
  end

  def login_or_create
    create_new_account unless login_successful?

    user
  end

  def login_successful?
    account = OauthAccount
              .where(provider: policy.provider, uid: policy.uid)
              .first
    if account.present?
      refresh_tokens account
      @user = account.user
      @user.update_attributes(user_params)
      @user.save

      true
    else
      false
    end
  end

  def refresh_tokens(account)
    account.update_attributes(
      oauth_secret: policy.oauth_secret,
      oauth_token: policy.oauth_token,
      oauth_expires: policy.oauth_expires,
      updated_at: Time.now
    )
  end

  def create_new_account
    @user = User.find_by_email(policy.email) || User.new(user_params)
    @user.oauth_accounts.create account_params if user.save
  end

  private

  def account_params
    {
      provider: provider,
      uid: policy.uid,
      oauth_secret: policy.oauth_secret,
      oauth_token: policy.oauth_token,
      oauth_expires: policy.oauth_expires,
      username: policy.nickname,
      user_id: user.id
    }
  end

  def user_params
    {
      first_name: policy.first_name,
      last_name: policy.last_name,
      email: policy.email
    }
  end
end
