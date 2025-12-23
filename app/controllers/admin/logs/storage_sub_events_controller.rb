# frozen_string_literal: true

class Admin::Logs::StorageSubEventsController < Admin::Controller
  # GET     /api/admin/logs/storage_sub_events
  def index
    run Platform::Log::StorageSubEvent::Admin::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Log::StorageSubEvent::Admin::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end
end
