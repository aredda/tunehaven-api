# frozen_string_literal: true

class User::UsersController < User::Controller
  # GET   /api/user/users/:id
  def show
    run User::Operation::Show do
      return render json: {
        success: true,
        data: User::View::Profile.with_options(current_user:).new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST  /api/user/users/:id/follow
  def follow
    run User::Operation::FollowUser do
      return render json: {
        success: true
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE  /api/user/users/:id/unfollow
  def unfollow
    run User::Operation::UnfollowUser do
      return render json: {
        success: true
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
