# frozen_string_literal: true

module FFMonads
  class Maybe
    def self.some(value)
      Some.new(value)
    end

    def self.none
      None.new
    end

    def inspect
      to_s
    end

    class Some < Maybe
      # rubocop: disable Lint/MissingSuper
      def initialize(value)
        @value = value
      end
      # rubocop: enable Lint/MissingSuper

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

      def !
        @value
      end

      def eql?(other)
        return false unless other.is_a?(Some)

        @value.eql?(other.!)
      end

      def to_s
        "some(#{@value})"
      end
    end

    class None < Maybe
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

      def !
        raise :no_value
      end

      def eql?(other)
        other.is_a?(None)
      end

      def to_s
        'none()'
      end
    end

    module Mixin
      def some(value)
        Maybe.some(value)
      end

      def none
        Maybe.none
      end
    end
  end
end
