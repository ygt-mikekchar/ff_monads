# frozen_string_literal: true

require_relative 'error'

module FFMonads
  # Represents a value for an operation that may fail.
  # Result is normally used in conjunction with `.map` or `.and_then`
  # to operate on a value where you want to concentrate on the
  # success path.  If the operation fails, the computation can
  # drop out to return a failure.
  # @example You can mix in this module.
  #   include FFMonads::Result::Mixin
  # @example A value from a successful operation.
  #   success(42)
  # @example A value from a failed operation.
  #   failure("divide by zero")
  class Result
    # Applies a potentially failed value to a block.
    # It takes the value from the Result, transforms it,
    # puts back into a Result and returns it.
    # @param block [Block] A block accepting the value and returning a transformed value.
    # @return [FFMonads::Result] The value from the block wrapped in a Result.
    # @example Called with success, it will always return success.
    #   success(42).map {|x| x + 1} # returns success(43)
    # @example Called with failure, it will always return failure.
    #   failure("divide by zero").map {|x| x + 1} # returns failure("divide by zero")
    def map(&block); end # rubocop: disable Naming/BlockForwarding

    # Applies an potentially failed value to a block.
    # It takes the value from the Result, transforms it,
    # and returns it without putting it back into a Result.
    # It assumes the block will put the value back into
    # a Result.
    # @param block [Block] A block accepting and returning a transformed value wrapped in a Result.
    # @return [FFMonads::Maybe] Result returned from the block.
    # @example `.and_then` allows you to choose the Result to return.
    #   # This returns failure
    #   success(0).and_then do |x|
    #     if x == 0
    #       failure("divide by zero")
    #     else
    #       success(100 / x)
    #     end
    #   end
    def and_then(&block); end # rubocop: disable Naming/BlockForwarding

    # Returns true if the Result is a failure.
    # @return [Boolean]
    def failure?; end

    # Returns true if the Result is a success.
    # @return [Boolean]
    def success?; end

    # Returns the value in the Result.
    # Raises NoValueError if the Result is a Failure.
    # @return [Something] the value in the Result.
    # @raise [FFMonads::NoValueError] if the Result is failure.
    def v!; end

    # Returns the value in a Failure.
    # Return nil if the Result is not a Failure.
    # @return [Something] the value in a Failure.
    def failure; end

    # Returns true if this Result contains an equivalent value as the other Result.
    # @param other [FFMonads::Result]
    # @return [Boolean]
    def eql?(other); end

    # Returns a string representation of the Result.
    # @return [String]
    # @example Mostly used for #inspect.
    #   success(42).to_s # returns "success(42)"
    #   failure("divide by zero").to_s # returns "failure"
    def to_s; end

    # Returns a hash representation of the Result.
    # Possibly for serialisation???
    # @return [Hash<Symbol, Value>]
    # @example
    #   success(42).to_h # returns { type: Success, value: 42 }
    #   failure("divide by zero").to_h # returns { type: Failure, value: "divide by zero" }
    def to_h; end

    # Returns a string representation of the Result
    # @see #to_s
    def inspect
      to_s
    end

    # Represents a value that succeeded.
    class Success < Result
      # rubocop: disable Lint/MissingSuper
      def initialize(value)
        @value = value
      end
      # rubocop: enable Lint/MissingSuper

      # deconstruct value for case statements
      # @return [Array]
      # @example
      #   case success(42)
      #   in Success(Integer => x)
      #     x
      #   in Failure(String => y)
      #     y
      #   end
      def deconstruct
        [@value]
      end

      def failure?
        false
      end

      def success?
        true
      end

      def map(&block)
        self.class.new(block.call(@value))
      end

      def and_then(&block)
        block.call(@value)
      end

      def v!
        @value
      end

      def failure
        nil
      end

      def eql?(other)
        return false unless other.is_a?(Success)

        @value.eql?(other.v!)
      end

      def to_s
        "success(#{@value.inspect})"
      end

      def to_h
        { type: Success, value: @value }
      end
    end

    class Failure < Result
      # rubocop: disable Lint/MissingSuper
      def initialize(value)
        @value = value
      end
      # rubocop: enable Lint/MissingSuper

      # deconstruct value for case statements
      # @return [Array]
      # @example
      #   case success(42)
      #   in Success(Integer => x)
      #     x
      #   in Failure(String => y)
      #     y
      #   end
      def deconstruct
        [@value]
      end

      def failure?
        true
      end

      def success?
        false
      end

      def map(&)
        self
      end

      def and_then(&)
        self
      end

      def v!
        raise(NoValueError, self)
      end

      def failure
        @value
      end

      def eql?(other)
        return false unless other.is_a?(Failure)

        @value.eql?(other.failure)
      end

      def to_s
        "failure(#{@value.inspect})"
      end

      def to_h
        { type: Failure, value: @value }
      end
    end

    # Mixin module for Result
    # @example You can mix in Result functionality with:
    #   include FFMonads::Result::Mixin
    module Mixin
      # Mix in Success and Failure constants to the current Class/Module.
      # Gives access to Success and Failure without needing a namespace.
      def add_classes
        const_set('Success', Success)
        const_set('Failure', Failure)
      end

      # Create a Success containing the value
      # @param value [Something] the value to wrap in a Success
      # @return [Something] The value wrapped in a Success
      def success(value)
        Success.new(value)
      end

      # Create a Failure containing the value
      # @param value [Something] the value to wrap in a Failure
      # @return [Something] The value wrapped in a Failure
      def failure(value)
        Failure.new(value)
      end
    end

    include Mixin
  end
end
