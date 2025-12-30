# frozen_string_literal: true

require "google/cloud/storage"

module Helpers
  class StorageManager
    class << self
      @bucket = nil

      def bucket
        return @bucket if @bucket.present?

        storage = Google::Cloud::Storage.new
        @bucket = storage.bucket ENV.fetch("GCS_BUCKET_NAME"), skip_lookup: true

        @bucket
      end
    end
  end
end
