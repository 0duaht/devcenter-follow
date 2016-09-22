class FollowWorker
  include Sidekiq::Worker

  def perform(oauth_id)
    current_account = OauthAccount.find(oauth_id)

    OauthAccount.where(provider: 'github')
                .merge(OauthAccount.where.not(id: oauth_id))
                .pluck(:username, :oauth_token)
                .each do |username, token|
      Github::Client::Users::Followers.new(
        oauth_token: current_account.oauth_token
      ).follow username

      Github::Client::Users::Followers.new(
        oauth_token: token
      ).follow current_account.username
    end
  end
end