# frozen_string_literal: true

class User::PlaylistsController < User::Controller
  # GET /api/user/playlists
  def index
    run User::Playlist::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: User::Playlist::View::Index.with_options(current_user:).for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET /api/user/playlists/:id
  def show
    run User::Playlist::Operation::Show do
      return render json: {
        success: true,
        data: User::Playlist::View::Show.with_options(current_user:).new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST  /api/user/playlists
  def create
    run User::Playlist::Operation::Create do
      return render json: {
        success: true,
        data: User::Playlist::View::Index.with_options(current_user:).new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT   /api/user/playlists/:id
  def update
    run User::Playlist::Operation::Update do
      return render json: {
        success: true,
        data: User::Playlist::View::Show.with_options(current_user:).new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT   /api/user/playlists/:id/toggle_visibility
  def toggle_visibility
    run User::Playlist::Operation::ToggleVisibility do
      return render json: {
        success: true
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE  /api/user/playlists/:id
  def destroy
    run User::Playlist::Operation::Destroy do
      return render json: {
        success: true
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # POST  /api/user/playlists/:id/toggle_save
  def toggle_save
    run User::Playlist::Operation::ToggleSave do
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
