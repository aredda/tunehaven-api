ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "shoulda-context"
require "shoulda-matchers"
require "devise/jwt/test_helpers"
require "fabrication"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def res_errors
      response.parsed_body["errors"]
    end

    def res_data
      response.parsed_body["data"]
    end

    def res_meta
      response.parsed_body["meta"]
    end
  end
end

class UserIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = Fabricate(:user)
    @auth_headers = Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, @user, scope: :user)

    post_setup
  end

  def post_setup; end
end
