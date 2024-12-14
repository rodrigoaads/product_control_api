Rails.application.config.to_prepare do
  ActiveModel::Errors.class_eval do
    def full_message(attribute, message)
      message
    end
  end
end
