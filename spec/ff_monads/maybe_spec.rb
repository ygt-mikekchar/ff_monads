# frozen_string_literal: true

require_relative '../../lib/ff_monads/maybe'
require_relative '../../lib/ff_monads/error'
require_relative '../../lib/ff_monads/escape'

RSpec.describe FFMonads::Maybe do
  include FFMonads::Maybe::Mixin
  extend FFMonads::Maybe::Mixin

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

    describe 'v!' do
      it 'returns the value' do
        expect(some(42).v!).to eql(42)
      end

      context 'ignoring return value' do
        include FFMonads::Escape::Mixin

        it 'does not trigger a Rubocop error' do
          expect(
            escape do
              none.v!
              some(100)
            end
          ).to eql(none)
        end
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

    describe 'v!' do
      it 'raises an exception' do
        expect { none.v! }.to raise_error(FFMonads::NoValueError)
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

  describe 'pattern matching' do
    it 'matches on classes' do
      result = case some(42)
               in FFMonads::Maybe::Some
                 true
               in FFMonads::Maybe::None
                 false
               end

      expect(result).to eql(true)
    end

    it 'matches on values' do
      result = case some(42)
               in FFMonads::Maybe::Some(Integer => x)
                 x
               in FFMonads::Maybe::None
                 nil
               end

      expect(result).to eql(42)
    end

    describe 'mixing in Some and None' do
      add_classes
      it 'can use Some' do
        result = case some(42)
                 in Some(Integer => x)
                   x
                 else
                   false
                 end

        expect(result).to eql(42)
      end

      it 'can use None' do
        result = case none
                 in None
                   true
                 else
                   false
                 end

        expect(result).to eql(true)
      end
    end
  end
end
