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
end
