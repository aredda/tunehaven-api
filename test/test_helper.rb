ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "shoulda-context"
require "shoulda-matchers"
require "devise/jwt/test_helpers"
require "fabrication"

# Minitest 6 removed `Object#stub` (it now lives in the minitest-mock gem).
# This dependency-free replacement stubs a single method for the duration of
# a block, keeping tests that touch external services hermetic.
module StubMethod
  def stub_method(receiver, name, value)
    singleton = receiver.singleton_class
    singleton.send(:alias_method, :"__stub_original_#{name}", name)

    singleton.define_method(name) do |*args, **kwargs, &block|
      value.respond_to?(:call) ? value.call(*args, **kwargs, &block) : value
    end

    yield
  ensure
    singleton.send(:remove_method, name)
    singleton.send(:alias_method, name, :"__stub_original_#{name}")
    singleton.send(:remove_method, :"__stub_original_#{name}")
  end
end

Minitest::Test.include(StubMethod)

# Isolate each parallel test worker's local uploads so that a per-test teardown
# in one process cannot delete files another process is still using.
module TestUploads
  def remove_test_uploads
    FileUtils.rm_rf(Rails.root.join("public/test/uploads/#{Process.pid}"))
  end
end

Minitest::Test.include(TestUploads)

Minitest.after_run { FileUtils.rm_rf(Rails.root.join("public/test")) }

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
    def res_errors = response.parsed_body["errors"]

    def res_data = response.parsed_body["data"]

    def res_meta = response.parsed_body["meta"]

    def res_success? = response.parsed_body["success"]
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

class AdminIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @admin = Fabricate(:admin)
    @auth_headers = Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, @admin, scope: :admin)

    post_setup
  end

  def post_setup; end
end
