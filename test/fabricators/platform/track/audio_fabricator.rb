# frozen_string_literal: true

Fabricator :track_audio, class_name: "Platform::Track::Audio" do
  track { Fabricate(:track) }
end
