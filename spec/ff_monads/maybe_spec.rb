# frozen_string_literal: true

require_relative '../../lib/ff_monads/maybe'

RSpec.describe FFMonads::Maybe do
  include FFMonads::Maybe::Mixin

  describe 'constructors' do
    describe 'some' do
      it 'creates a Maybe with a value' do
        expect(some(42).to_s).to eql('some(42)')
      end
    end

    describe 'none' do
      it 'creates a Maybe without a value' do
        expect(none.to_s).to eql('none()')
      end
    end
  end
end
