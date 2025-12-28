# frozen_string_literal: true

module PubSub::Operation
  class Process < ApplicationOperation
    step :process_notification
    pass :log_event

    def process_notification(context, notification:, **)
      data = JSON.parse(notification.message.data)
      filename = context[:filename] = data["name"]
      content_type = context[:content_type] = data["contentType"]
      context[:media_link] = data["mediaLink"]

      return false unless %w[audio/flac image/jpeg image/png].include? content_type

      return false unless filename.include? "/library/"

      entities = (filename.split "/library/").last

      return false if entities.nil?

      segments = entities.split "/"

      return false if segments.count != 3

      context[:segments] = segments
    end

    def log_event(_context, notification:, filename:, **)
      unless Rails.env.test?
        event_type = notification.message.attributes["eventType"]

        puts "[#{Time.now.strftime("%m/%d/%Y %I:%M%p")}] - [#{event_type}] - [#{filename}]"
      end
    end
  end
end
