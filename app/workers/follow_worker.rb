class FollowWorker
  include Sidekiq::Worker

  def perform(oauth_id)
    current_account = OauthAccount.find(oauth_id)

    OauthAccount.where(provider: 'github')
                .merge(OauthAccount.where.not(id: oauth_id))
                .each do |oauth_account|
      next unless oauth_account.follow current_account
      current_account.follow oauth_account
    end
  end
end
