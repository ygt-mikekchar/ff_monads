# frozen_string_literal: true

require_relative 'error'

module FFMonads
  # Represents an optional value.
  # Maybe is normally used in conjunction with `.map` or `.and_then`
  # to operate on an optional value without crashing when the value
  # does not exist.
  # @example You can mix in this module.
  #   include FFMonads::Maybe::Mixin
  # @example a value that exists.
  #   some(42)
  # @example a value that does not exist.
  #   none
  class Maybe
    # Applies an optional value to a block.
    # It takes the value from the Maybe, transforms it,
    # puts back into a Maybe and returns it.
    # @param block [Block] a block accepting the value and returning a transformed value.
    # @return [FFMonads::Maybe] the value from the block wrapped in a Maybe.
    # @example Called with some, it will always return some.
    #   some(42).map {|x| x + 1} # returns some(43)
    # @example Called with none, it will always return none.
    #   none.map {|x| x + 1} # returns none
    #: () { [T, U] (T) -> U } -> Maybe[U]
    def map(&block); end

    # Applies an optional value to a block.
    # It takes the value from the Maybe, transforms it,
    # and returns it without putting it back into a Maybe.
    # It assumes the block will put the value back into
    # a Maybe.
    # @param block [Block] a block accepting and returning a transformed value wrapped in a Maybe.
    # @return [FFMonads::Maybe] Maybe returned from the block.
    # @example `.and_then` allows you to choose the Maybe to return.
    #   # This returns none
    #   some(0).and_then do |x|
    #     if x == 0
    #       none
    #     else
    #       some(100 / x)
    #     end
    #   end
    #: () { [T, U] (T) -> Maybe[U] } -> Maybe[U]
    def and_then(&block); end

    # Returns true if the Maybe is none.
    # @return [Boolean]
    # () -> bool
    def none?; end

    # Returns true if the Maybe is some.
    # @return [Boolean]
    # () -> bool
    def some?; end

    # Returns the value in the Maybe.
    # Raises NoValueError if the Maybe is none.
    # @return [Something] the value in the Maybe.
    # @raise [FFMonads::NoValueError] if the Maybe is none.
    #: [T] () -> T
    def value!; end

    # Returns true if this Maybe contains an equivalent value as the other Maybe.
    # @param other [FFMonads::Maybe] the other Maybe to compare to
    # @return [Boolean]
    #: (Maybe) -> bool
    def eql?(other); end

    # Returns a string representation of the Maybe
    #: () -> String
    def inspect; end

    # Returns a hash representation of the Maybe.
    # Possibly for serialisation???
    # @return [Hash<Symbol, Value>]
    # @example
    #   some(42).to_h # returns { type: Some, value: 42 }
    #   none.to_h     # returns { type: None, value: nil }
    #: () -> Hash[Symbol, untyped]
    def to_h; end

    # Returns a string representation of the Maybe
    # @return [String]
    # @example
    #   some(42).inspect # returns "Some(42)"
    #   none().inspect # returns "None()"
    def inspect; end

    # Represents a value that exists.
    class Some < Maybe
      # rubocop: disable Lint/MissingSuper
      def initialize(value)
        @value = value
      end
      # rubocop: enable Lint/MissingSuper

      # deconstruct value for case statements
      # @return [Array]
      # @example
      #   case some(42)
      #   in Some(Integer => x)
      #     x
      #   in None
      #     0
      #   end
      # [T] () -> Array[T]
      def deconstruct
        [@value]
      end

      # () -> bool
      def none?
        false
      end

      # () -> bool
      def some?
        true
      end

      #: () { [T, U] (T) -> U } -> Maybe[U]
      def map(&block)
        self.class.new(block.call(@value))
      end

      #: () { [T, U] (T) -> Maybe[U] } -> Maybe[U]
      def and_then(&block)
        block.call(@value)
      end

      #: [T] () -> T
      def value!
        @value
      end

      #: (Maybe) -> bool
      def eql?(other)
        return false unless other.is_a?(Some)

        @value.eql?(other.value!)
      end

      #: () -> String
      def inspect
        "Some(#{@value.inspect})"
      end

      # FIXME: Try to find something better than this
      #: () -> Hash[Symbol, untyped]
      def to_h
        { type: Some, value: @value }
      end
    end

    # Represents a value that doesn't exist
    class None < Maybe
      # deconstruct value for case statements
      # @return [Array]
      # @example
      #   case some(42)
      #   in Some(Integer => x)
      #     x
      #   in None
      #     0
      #   end
      # () -> Array
      def deconstruct
        []
      end

      # () -> bool
      def none?
        true
      end

      # () -> bool
      def some?
        false
      end

      #: () { [T, U] (T) -> U } -> Maybe[U]
      def map(&)
        self
      end

      #: () { [T, U] (T) -> Maybe[U] } -> Maybe[U]
      def and_then(&)
        self
      end

      #: [T] () -> T
      def value!
        raise(NoValueError, self)
      end

      #: (Maybe) -> bool
      def eql?(other)
        other.is_a?(None)
      end

      #: () -> String
      def inspect
        'None()'
      end

      # FIXME: Try to find something better than this
      #: () -> Hash[Symbol, untyped]
      def to_h
        { type: None, value: nil }
      end
    end

    # Mixin module for Maybe
    # @example You can mix in Maybe functionality with:
    #   include FFMonads::Maybe::Mixin
    module Mixin
      # Mix in None and Some constants to the current Class/Module.
      # Gives access to None and Some without needing a namespace.
      #: () -> void
      def add_classes
        const_set('Some', Some)
        const_set('None', None)
      end

      # Create a Some containing the value
      # @param value [Something] the value to wrap in a Some
      # @return [Something] The value wrapped in a Some
      #: [T] (T) -> Some[T]
      def some(value)
        Some.new(value)
      end

      # Create a None
      # @return [None]
      #: () -> None
      def none
        None.new
      end
    end

    include Mixin
  end
end
