# frozen_string_literal: true

require_relative '../lib/ff_monads'

RSpec.describe FFMonads do
  describe 'Mixin with extend' do
    module Foo
      extend FFMonads
    end

    it 'does something' do
      expect(Foo.some(42).to_s).to eql('some(42)')
    end
  end
end
