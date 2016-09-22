class GithubPolicy < BasePolicy
  def oauth_expires
    nil
  end

  def oauth_secret
    nil
  end

  def nickname
    auth_data.info.nickname
  end
end
