# frozen_string_literal: true

module ServiceResponse
  class Success
    def initialize(payload)
      @payload = payload
    end

    def success?
      true
    end

    def data
      @payload
    end
  end

  class Error
    def initialize(errors)
      @errors = errors
    end

    def success?
      false
    end

    def errors
      @errors
    end
  end
end
