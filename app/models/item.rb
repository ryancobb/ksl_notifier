class Item < ApplicationRecord
  scope :by_user, -> (user) { where(:user_id => user.id) }

  def query_params
    parse_query_params
  end

  private

  def parse_query_params
    CGI.parse(URI.parse(search_url).query)
  end
end
