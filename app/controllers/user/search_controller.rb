# frozen_string_literal: true

class User::SearchController < User::Controller
  before_action :use_unsafe_params, only: :show

  # GET   /api/user/search?query=&type=
  def show
    run User::Operation::Search do |context|
      result = context[:finder].result
      view = case params[:type]
      when "track" then Platform::Track::View::Index.with_options(current_user:)
      when "album" then Platform::Album::View::Index
      when "artist" then Platform::Artist::View::Index
      when "playlist" then User::Playlist::View::Base
      else return false
      end

      return render json: {
        success: true,
        data: view.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
