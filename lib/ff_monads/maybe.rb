# frozen_string_literal: true

module FFMonads
  class Maybe
    def self.some(value)
      new(value)
    end

    def self.none
      None.new
    end

    def initialize(value)
      @value = value
    end

    def none?
      false
    end

    def some?
      true
    end

    def map(&block)
      block.call(@value)
    end

    def and_then(&block)
      self.class.some(block.call(@value))
    end

    def !
      @value
    end

    def to_s
      "some(#{@value})"
    end

    def inspect
      to_s
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
