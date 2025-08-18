# frozen_string_literal: true

require 'test_helper'

class User::SessionsControllerTest < ActionDispatch::IntegrationTest
  test '#sign_in' do
    Fabricate(:user, email: 'brando@gmail.com', password: '12345678')

    # failure: invalid email
    post '/api/user/sign_in', params: {
      user: {
        email: 'invalid_email',
        password: 'invalid_password'
      }
    }

    assert_response :unauthorized
    assert_equal ['invalid email or password'], response.parsed_body['errors']['base']

    # failure: invalid password
    post '/api/user/sign_in', params: {
      user: {
        email: 'brando@gmail.com',
        password: 'invalid_password'
      }
    }

    assert_response :unauthorized
    assert_equal ['invalid email or password'], response.parsed_body['errors']['base']

    # success
    post '/api/user/sign_in', params: {
      user: {
        email: 'brando@gmail.com',
        password: '12345678'
      }
    }

    assert_response :ok
    assert_not_nil response.parsed_body['token']
  end

  test '#sign_out' do
    user = Fabricate(:user, email: 'brando@gmail.com', password: '12345678')
    headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, user, scope: :user)

    # logged in
    post '/api/user/sign_in', params: {
      user: {
        email: 'brando@gmail.com',
        password: '12345678'
      }
    }

    assert_response :ok
    assert_not_nil response.parsed_body['token']

    get '/api/user/me', headers: headers

    assert_response :success
    assert response.parsed_body['success']
    assert_predicate response.parsed_body['user'], :present?

    # log out
    delete '/api/user/sign_out', headers: headers

    assert_response :success

    # assert he is no longer logged in
    get '/api/user/me', headers: headers

    assert_response :unauthorized
  end
end
