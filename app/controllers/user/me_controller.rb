# frozen_string_literal: true

class User::MeController < User::Controller
  # GET   /api/user
  def show
    render json: {
      success: true,
      user: User::View::Session.new(current_user)
    }, status: :ok
  end

  # GET   /api/user/me/followers
  def followers
    run User::Operation::FollowersIndex do
      return render json: {
        success: true,
        data: User::View::Profile.with_options(current_user:).for_collection.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # GET   /api/user/me/following
  def following
    run User::Operation::FollowingIndex do
      return render json: {
        success: true,
        data: User::View::Profile.with_options(current_user:).for_collection.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
