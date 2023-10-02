# frozen_string_literal: true

module FFMonads
  class NoValueError < StandardError
    attr_reader :source

    def initialize(source)
      @source = source
      super("Attempt to access unset value in monad: #{source.to_h.inspect}")
    end
  end
end
