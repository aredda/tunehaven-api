# frozen_string_literal: true

module User::Setting::Operation
  class Create < ApplicationOperation
    step Model(OpenStruct, :new)
    step Contract::Build(constant: User::Setting::Form::Create)
    step Contract::Validate()
    step :allocate_settings

    def allocate_settings(_context, current_user:, params:, **)
      params[:settings].map do |entry|
        setting = current_user.settings.find_or_initialize_by(key: entry[:key])
        setting.value = entry[:value]
        setting.save
      end
    end
  end
end
