# frozen_string_literal: true

require "reform/form/coercion"
require "reform/form/dry"

class ApplicationForm < Reform::Form
  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  VALID_PHONE_REGEX = /\+?([\d|\(][\h|\(\d{3}\)\.\-]{4,}\d)/i
  VALID_LOCALES = /en|fr|es/i

  feature Dry
  feature Coercion

  module Types
    include Dry.Types(:strict, :coercible)

    OptionalField = Types::Coercible::String.constructor { |x| x.nil? ? Undefined : x }
    StrippedString = Types::Coercible::String.constructor(&:strip)
    NarrowString = Types::Coercible::String.constructor { |x| x.delete(" ") }
    NullableString = Types::Coercible::String.constructor(&:presence)
    FloatType = Types::Coercible::String.constructor(&:to_f)
    IntegerType = Types::Coercible::String.constructor(&:to_i)
  end

  class BaseContract < ::Dry::Validation::Contract
    register_macro(:is_file?) do
      key.failure("Invalid file input.") unless value.is_a? ActionDispatch::Http::UploadedFile
    end
  end
end
