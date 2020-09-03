class Error
  attr_reader :id, :message

  def initialize(message)
    @id = nil
    @message = message
  end

  class << self
    def missing_params
      message = 'Missing required fields'
      create_error(message)
    end

    def mismatched_passwords
      message = 'Whoops, these passwords do not match'
      create_error(message)
    end

    def same_email
      message = 'Email is already in use'
      create_error(message)
    end

    def create_error(message)
      error = Error.new(message)
      ErrorSerializer.new(error)
    end
  end
end
