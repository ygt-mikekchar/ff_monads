# frozen_string_literal: true

require_relative 'error'

module FFMonads
  # Catch `NoValueError` exceptions, returning the monad that caused the issue.
  # @example You can mix in this module.
  #   include FFMonads::Escape::Mixin
  module Escape
    # Return early from the given block if an evaluated monad has no value.
    # @param [Proc] block The block to call.
    # @return [FFMonads::Maybe] The monad returned from the block.
    # @example Monads that can be unwrapped will simply run to the end of the block.
    #   monad = some(42)
    #   escape do
    #     value = monad.v! # monad has a value so it will continue
    #     some(value + 1)  # it will return some(43)
    #   end
    # @example Monads that can't be unwrapped will return early
    #   monad = none
    #     escape do
    #       value = monad.v! # monad does not have a value so it will return none here
    #       some(value + 1)  # this line will never be reached
    #     end
    def self.escape(&block)
      block.call
    rescue NoValueError => e
      e.source
    end

    module Mixin
      def escape(&)
        Escape.escape(&)
      end
    end
  end
end
