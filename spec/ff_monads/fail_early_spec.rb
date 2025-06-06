# frozen_string_literal: true

require_relative '../../lib/ff_monads/error'
require_relative '../../lib/ff_monads/maybe'
require_relative '../../lib/ff_monads/fail_early'

RSpec.describe FFMonads::FailEarly do
  include FFMonads::FailEarly::Mixin

  context FFMonads::Maybe do
    include FFMonads::Maybe::Mixin

    context 'fail_early with value!' do
      context FFMonads::Maybe::Some do
        it 'returns return value from the block' do
          monad = some(42)
          result = fail_early { some(monad.value! + 1) }

          expect(result).to eql(some(43))
        end
      end

      context FFMonads::Maybe::None do
        it 'returns none' do
          monad = none
          result = fail_early { some(monad.value! + 1) }

          expect(result).to eql(none)
        end
      end
    end
  end
end
