# frozen_string_literal: true

require_relative 'result'
require_relative 'maybe'
require_relative 'escape'

module FFMonads
  include Maybe::Mixin
  include Result::Mixin
  include Escape::Mixin
end
