# frozen_string_literal: true

require_relative '../../lib/ff_monads/error'
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

  describe FFMonads::Maybe::Some do
    describe 'none?' do
      it 'always returns false' do
        expect(some(42).none?).to eql(false)
      end
    end

    describe 'some?' do
      it 'always returns true' do
        expect(some(42).some?).to eql(true)
      end
    end

    describe 'map' do
      it 'applies the value to a block, wrapping the result' do
        expect(some(42).map { |x| x + 1 }).to eql(some(43))
      end
    end

    describe 'and_then' do
      it 'applies the value to a block, returning what the block returns' do
        expect(some(42).and_then { |_| none }).to eql(none)
      end
    end

    describe '!' do
      it 'returns the value' do
        expect(some(42).!).to eql(42)
      end
    end

    describe 'eql?' do
      context 'other is a Some containing the same value' do
        it 'returns true' do
          expect(some(42)).to eql(some(42))
        end
      end

      context 'other is a Some containing a different value' do
        it 'returns false' do
          expect(some(42)).to_not eql(some(10))
        end
      end

      context 'other is a different class' do
        it 'returns false' do
          expect(some(42)).to_not eql(42)
        end
      end
    end

    describe 'to_s' do
      it 'outputs the value as a string' do
        expect(some(42).to_s).to eql('some(42)')
      end

      it 'nests' do
        expect(some(some(42)).to_s).to eql('some(some(42))')
      end
    end
  end

  describe FFMonads::Maybe::None do
    describe 'none?' do
      it 'always returns true' do
        expect(none.none?).to eql(true)
      end
    end

    describe 'some?' do
      it 'always returns false' do
        expect(none.some?).to eql(false)
      end
    end

    describe 'map' do
      it 'returns none' do
        expect(none.map { |x| x + 1 }).to eql(none)
      end
    end

    describe 'and_then' do
      it 'returns none' do
        expect(none.and_then { |_| none }).to eql(none)
      end
    end

    describe '!' do
      it 'raises an exception' do
        expect { none.! }.to raise_error(FFMonads::NoValueError)
      end
    end

    describe 'eql?' do
      context 'other is a None' do
        it 'returns true' do
          expect(none).to eql(none)
        end
      end

      context 'other is a Some containing a value' do
        it 'returns false' do
          expect(none).to_not eql(some(42))
        end
      end

      context 'other is a different class' do
        it 'returns false' do
          expect(none).to_not eql(42)
        end
      end
    end

    describe 'to_s' do
      it 'outputs the value as a string' do
        expect(none.to_s).to eql('none()')
      end
    end
  end
end
