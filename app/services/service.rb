module Service
  extend ActiveSupport::Concern

  included do
    def ok(**params)
      OpenStruct.new(error?: false,
                     **params)
    end

    def error(msg, **params)
      OpenStruct.new(error?: true,
                     error_message: msg,
                     **params)
    end
  end

  class_methods do
    def call(**params)
      new(**params).call
    end
  end
end
