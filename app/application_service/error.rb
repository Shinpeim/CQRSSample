require 'application_service'

module ApplicationService
  class Error < StandardError; end

  class ValidationError < Error
    attr_reader :details

    def initialize(details)
      @details = details
    end
  end
end
