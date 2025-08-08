# frozen_string_literal: true

class ApplicationFinder < Trailblazer::Finder
  adapter :ActiveRecord
  paginator :Kaminari

  paging per_page: 10, min_per_page: 1, max_per_page: 50
end
