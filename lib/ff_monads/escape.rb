# frozen_string_literal: true

require_relative 'error'

module FFMonads
  module Escape
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
