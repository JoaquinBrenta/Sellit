class FetchCountryJob < ApplicationJob
  queue_as :default

  def perform(user_id, ip_address)
     country = FetchCountryService.new(ip).perform
     user = User.find(user_id)
    if country
        user.update(country: country)
    end
  end
end
