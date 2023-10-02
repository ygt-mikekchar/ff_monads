# frozen_string_literal: true

require_relative '../../lib/ff_monads/error'
require_relative '../../lib/ff_monads/maybe'
require_relative '../../lib/ff_monads/escape'

RSpec.describe FFMonads::Escape do
  include FFMonads::Escape::Mixin

  context FFMonads::Maybe do
    include FFMonads::Maybe::Mixin

    context FFMonads::Maybe::Some do
      it 'returns the Maybe on success' do
        monad = some(42)
        result = escape do
          some(monad.! + 1)
        end

        expect(result).to eql(some(43))
      end
    end

    context FFMonads::Maybe::None do
      it 'returns the Maybe on success' do
        monad = none
        result = escape do
          some(monad.! + 1)
        end

        expect(result).to eql(none)
      end
    end
  end
end
