# frozen_string_literal: true

require_relative 'maybe'

module FFMonads
  include Maybe::Mixin
  include Escape::Mixin
end
