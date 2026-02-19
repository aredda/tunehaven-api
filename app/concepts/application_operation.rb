# frozen_string_literal: true

class ApplicationOperation < Trailblazer::Operation
  class << self
    alias fall fail
  end

  def fail_error(context, message, message_key = :base)
    context["contract.default"] = ApplicationForm.new nil
    context["contract.default"].errors.add(message_key, message)
  end

  def fail_not_found(ctx, **)
    ctx["contract.default"] = ApplicationForm.new nil
    ctx["contract.default"].errors.add(:base, fail_not_found_message(ctx))
  end

  def exception_handler(exception, context)
    fail_error(context, exception.message)
  end

  def fail_not_found_message(_context)
    I18n.t("errors.not_found?")
  end
end
