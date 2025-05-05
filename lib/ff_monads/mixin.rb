# frozen_string_literal: true

require_relative 'result'
require_relative 'maybe'
require_relative 'fail_early'

module FFMonads
  include Maybe::Mixin
  include Result::Mixin
  include FailEarly::Mixin
end
