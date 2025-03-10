require_relative "request_forgery_protection_fallback"

module StaticRails
  class GetsCsrfToken
    include RequestForgeryProtectionFallback

    def call(req)
      masked_authenticity_token()
    end

    private

    [
      :csrf_token_hmac,
      :mask_token,
      :xor_byte_strings
    ].each do |method|
      define_method method do |*args, **kwargs, &blk|
        ActionController::RequestForgeryProtection.instance_method(method).bind(self).call(*args, **kwargs, &blk)
      end
    end

    def masked_authenticity_token(form_options: {})
      ActionController::RequestForgeryProtection.instance_method(:masked_authenticity_token).bind(self).call(form_options: form_options)
    end

    def global_csrf_token()
      ActionController::RequestForgeryProtection.instance_method(:global_csrf_token).bind(self).call()
    end

    def real_csrf_token(session)
      ActionController::RequestForgeryProtection.instance_method(:real_csrf_token).bind(self).call()
    end

    def per_form_csrf_tokens
      false
    end

    def urlsafe_csrf_tokens
      Rails.application.config.action_controller.urlsafe_csrf_tokens
    end
  end
end
