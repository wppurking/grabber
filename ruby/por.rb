require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = {namespace: "sidekiq", url: "redis://localhost:6379"}
end

Sidekiq.configure_client do |config|
  config.redis = {namespace: "sidekiq", url: "redis://localhost:6379", size: 1}
end


class PlanOldRuby
  include Sidekiq::Worker

  def perform(how_hard="super hard", how_long=5)
    sleep how_long
    puts "Workin' #{how_hard}"
  end
end