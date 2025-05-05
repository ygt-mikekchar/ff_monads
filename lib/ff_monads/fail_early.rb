# frozen_string_literal: true

require_relative 'error'

module FFMonads
  # Catch `NoValueError` exceptions, returning the monad that caused the issue.
  # @example You can mix in this module.
  #   include FFMonads::FailEarly::Mixin
  module FailEarly
    # Return early from the given block if an evaluated monad has no value.
    # @param block [Proc] The block to call.
    # @return [FFMonads::Maybe] The monad returned from the block.
    # @example Monads that can be unwrapped will simply run to the end of the block.
    #   monad = some(42)
    #   fail_early do
    #     value = monad.value! # monad has a value so it will continue
    #     some(value + 1)  # it will return some(43)
    #   end
    # @example Monads that can't be unwrapped will return early
    #   monad = none
    #     fail_early do
    #       value = monad.value! # monad does not have a value so it will return none here
    #       some(value + 1)  # this line will never be reached
    #     end
    def self.fail_early(&block)
      block.call
    rescue NoValueError => e
      e.source
    end

    module Mixin
      # Return early from the given block if an evaluated monad has no value.
      # @param block [Block] The block to call.
      # @return [FFMonads::Maybe] The monad returned from the block.
      # @example Monads that can be unwrapped will simply run to the end of the block.
      #   monad = some(42)
      #   fail_early do
      #     value = monad.value! # monad has a value so it will continue
      #     some(value + 1)  # it will return some(43)
      #   end
      # @example Monads that can't be unwrapped will return early
      #   monad = none
      #     fail_early do
      #       value = monad.value! # monad does not have a value so it will return none here
      #       some(value + 1)  # this line will never be reached
      #     end
      def fail_early(&block)
        FailEarly.fail_early(&block)
      end
    end
  end
end
