class OauthAccount < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user

  def follow(account)
    Github::Client::Users::Followers.new(
      oauth_token: oauth_token
    ).follow account.username
  rescue
    false
  end

  def unfollow(account)
    Github::Client::Users::Followers.new(
      oauth_token: oauth_token
    ).unfollow account.username
  end

  def github_link
    "https://github.com/#{username}"
  end

  def time_distance

  end
end
