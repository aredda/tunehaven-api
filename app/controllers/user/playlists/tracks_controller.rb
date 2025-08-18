# frozen_string_literal: true

module User::Playlists
  class TracksController < User::Controller
    # GET     /api/user/playlists/:playlist_id/tracks
    def index
      run User::PlaylistTrack::Operation::Index do |context|
        result = context[:finder].result

        return render json: {
          success: true,
          data: User::PlaylistTrack::View::Index.for_collection.new(result),
          meta: MetaView.new(result)
        }, status: :ok
      end

      render json: {
        success: false,
        errors: @form.errors.messages
      }, status: :not_found
    end

    # POST    /api/user/playlists/:playlist_id/tracks
    def create
      run User::PlaylistTrack::Operation::Create do
        return render json: {
          success: true,
          data: User::PlaylistTrack::View::Index.new(@model)
        }, status: :created
      end

      render json: {
        success: false,
        errors: @form.errors.messages
      }, status: :unprocessable_entity
    end

    # DELETE  /api/user/playlists/:playlist_id/tracks/:id
    def destroy
      run User::PlaylistTrack::Operation::Destroy do
        return render json: {
          success: true
        }, status: :ok
      end

      render json: {
        success: false,
        errors: @form.errors.messages
      }, status: :unprocessable_entity
    end
  end
end
