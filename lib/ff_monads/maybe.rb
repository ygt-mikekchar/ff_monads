# frozen_string_literal: true

require_relative 'error'

module FFMonads
  class Maybe
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

      def to_h
        { type: Some, value: @value }
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
