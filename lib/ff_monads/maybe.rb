# frozen_string_literal: true

require_relative 'error'

module FFMonads
  # Represents an optional value.
  # Maybe is normally used in conjunction with `.map` or `.and_then`
  # to operate on an optional value without crashing when the value
  # does not exist.
  # @example You can mix in this module.
  #   include FFMonads::Maybe::Mixin
  # @example A value that exists.
  #   some(42)
  # @example A value that does not exist.
  #   none
  class Maybe
    # Applies an optional value to a block.
    # It takes the value from the Maybe, transforms it,
    # puts back into a Maybe and returns it.
    # @param [Block] A block accepting the value and returning a transformed value.
    # @return [FFMonads::Maybe] The value from the block wrapped in a Maybe.
    # @example Called with some, it will always return some.
    #   some(42).map {|x| x + 1} # returns some(43)
    # @example Called with none, it will always return none.
    #   none.map {|x| x + 1} # returns none
    def map(&); end

    # Applies an optional value to a block.
    # It takes the value from the Maybe, transforms it,
    # and returns it without putting it back into a Maybe.
    # It assumes the block will put the value back into
    # a Maybe (or other monad).
    # @param [Block] A block accepting and returning a transformed value wrapped in a Monad.
    # @return [FFMonads::Maybe] Monad returned from the block.
    # @example `.and_then` allows you to choose the monad to return.
    #   # This returns none
    #   some(0).and_then do |x|
    #     if x == 0
    #       none
    #     else
    #       some(100 / x)
    #     end
    #   end
    def and_then(&); end

    # Returns true if the Maybe is none.
    # @return [Boolean]
    def none?; end

    # Returns true if the Maybe is some.
    # @return [Boolean]
    def some?; end

    # Returns the value in the Maybe.
    # Raises NoValueError if the Maybe is none.
    # @return [Something] the value in the Maybe.
    # @raise [FFMonads::NoValueError] if the Maybe is none.
    def v!; end

    # Returns true if this Maybe contains an equivalent value as the other Maybe.
    # @param [FFMonads::Maybe] other
    # @return [Boolean]
    def eql?; end

    # Returns a string representation of the Maybe.
    # @return [String]
    # @example Mostly used for #inspect.
    #   some(42).to_s # returns "some(42)"
    #   none.to_s     # returns "none"
    def to_s; end

    # Returns a hash representation of the Maybe.
    # Possibly for serialisation???
    # @return [Hash<Symbol, Value>]
    # @example
    #   some(42).to_h # returns { type: Some, value: 42 }
    #   none.to_h     # returns { type: None }
    def to_h; end

    # Returns a string representation of the Maybe
    # @see #to_s
    def inspect
      to_s
    end

    class Some < Maybe
      # rubocop: disable Lint/MissingSuper
      def initialize(value)
        @value = value
      end
      # rubocop: enable Lint/MissingSuper

      def deconstruct
        [@value]
      end

      def none?
        false
      end

      def some?
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

      def eql?(other)
        return false unless other.is_a?(Some)

        @value.eql?(other.v!)
      end

      def to_s
        "some(#{@value})"
      end

      def to_h
        { type: Some, value: @value }
      end
    end

    class None < Maybe
      def deconstruct
        []
      end

      def none?
        true
      end

      def some?
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

      def eql?(other)
        other.is_a?(None)
      end

      def to_s
        'none()'
      end

      def to_h
        { type: None }
      end
    end

    module Mixin
      def add_classes
        const_set('Some', Some)
        const_set('None', None)
      end

      def some(value)
        Some.new(value)
      end

      def none
        None.new
      end
    end

    include Mixin
  end
end
