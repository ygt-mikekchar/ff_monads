# frozen_string_literal: true

require_relative '../../lib/ff_monads/error'
require_relative '../../lib/ff_monads/maybe'
require_relative '../../lib/ff_monads/escape'

RSpec.describe FFMonads::Escape do
  include FFMonads::Escape::Mixin

  context FFMonads::Maybe do
    include FFMonads::Maybe::Mixin

    context 'escape with value!' do
      context FFMonads::Maybe::Some do
        it 'returns return value from the block' do
          monad = some(42)
          result = escape { some(monad.value! + 1) }

          expect(result).to eql(some(43))
        end
      end

      context FFMonads::Maybe::None do
        it 'returns none' do
          monad = none
          result = escape { some(monad.value! + 1) }

          expect(result).to eql(none)
        end
      end
    end
  end
end
