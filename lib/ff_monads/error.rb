# frozen_string_literal: true

module FFMonads
  # This exception will get raised when trying to get the value of
  # a monad that has no value set.  For example `none.value!`.
  class NoValueError < StandardError
    attr_reader :source

    # @param source [FFMonads::Maybe] The monad involved in the error.
    def initialize(source)
      @source = source
      super("Attempt to access unset value in monad: #{source.to_h.inspect}")
    end
  end
end
