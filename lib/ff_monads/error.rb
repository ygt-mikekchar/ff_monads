# frozen_string_literal: true

module FFMonads
  class NoValueError < StandardError
    attr_reader :contents

    def initialize(monad)
      @contents = monad.to_h
      super("Attempt to access unset value in monad: #{contents.inspect}")
    end
  end
end
