class BaseError < StandardError
  attr_accessor :source

  def initialize(message, source = nil)
    @source = source
    super message
  end
end