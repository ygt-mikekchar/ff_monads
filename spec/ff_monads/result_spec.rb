# frozen_string_literal: true

require_relative '../../lib/ff_monads/result'
require_relative '../../lib/ff_monads/error'
require_relative '../../lib/ff_monads/escape'

RSpec.describe FFMonads::Result do
  include FFMonads::Result::Mixin
  extend FFMonads::Result::Mixin

  describe 'constructors' do
    describe 'success' do
      it 'creates a Result with a successful value' do
        expect(success(42).inspect).to eql('Success(42)')
      end
    end

    describe 'failure' do
      it 'creates a Maybe with a failed value' do
        expect(failure('divide by zero').inspect).to eql('Failure("divide by zero")')
      end
    end
  end

  describe FFMonads::Result::Success do
    describe 'failure?' do
      it 'always returns false' do
        expect(success(42).failure?).to eql(false)
      end
    end

    describe 'success?' do
      it 'always returns true' do
        expect(success(42).success?).to eql(true)
      end
    end

    describe 'map' do
      it 'applies the value to a block, wrapping the result' do
        expect(success(42).map { |x| x + 1 }).to eql(success(43))
      end
    end

    describe 'and_then' do
      it 'applies the value to a block, returning what the block returns' do
        expect(success(42).and_then { |_| failure('foobar') }).to eql(failure('foobar'))
      end
    end

    describe 'v!' do
      it 'returns the value' do
        expect(success(42).v!).to eql(42)
      end

      context 'ignoring return value' do
        include FFMonads::Escape::Mixin

        it 'does not trigger a Rubocop error' do
          expect(
            escape do
              failure('foobar').v!
              success(100)
            end
          ).to eql(failure('foobar'))
        end
      end
    end

    describe 'eql?' do
      context 'other is a Success containing the same value' do
        it 'returns true' do
          expect(success(42)).to eql(success(42))
        end
      end

      context 'other is a Success containing a different value' do
        it 'returns false' do
          expect(success(42)).to_not eql(success(10))
        end
      end

      context 'other is a different class' do
        it 'returns false' do
          expect(success(42)).to_not eql(42)
        end
      end
    end

    describe 'inspect' do
      it 'outputs the value as a string' do
        expect(success(42).inspect).to eql('Success(42)')
      end

      it 'nests' do
        expect(success(success(42)).inspect).to eql('Success(Success(42))')
      end
    end
  end

  describe FFMonads::Result::Failure do
    describe 'failure?' do
      it 'always returns true' do
        expect(failure('foobar').failure?).to eql(true)
      end
    end

    describe 'success?' do
      it 'always returns false' do
        expect(failure('foobar').success?).to eql(false)
      end
    end

    describe 'map' do
      it 'returns failure' do
        expect(failure('foobar').map { |x| x + 1 }).to eql(failure('foobar'))
      end
    end

    describe 'and_then' do
      it 'returns failure' do
        expect(failure('foobar').and_then { |_| success(42) }).to eql(failure('foobar'))
      end
    end

    describe 'v!' do
      it 'raises an exception' do
        expect { failure('foobar').v! }.to raise_error(FFMonads::NoValueError)
      end
    end

    describe 'eql?' do
      context 'other is a Failure' do
        context 'with the same value' do
          it 'returns true' do
            expect(failure('foobar')).to eql(failure('foobar'))
          end
        end

        context 'with a different value' do
          it 'returns false' do
            expect(failure('foobar')).to_not eql(failure('baz'))
          end
        end
      end

      context 'other is a Success containing a value' do
        it 'returns false' do
          expect(failure('foobar')).to_not eql(success(42))
        end
      end

      context 'other is a different class' do
        it 'returns false' do
          expect(failure('foobar')).to_not eql(42)
        end
      end
    end

    describe 'inspect' do
      it 'outputs the value as a string' do
        expect(failure('foobar').inspect).to eql('Failure("foobar")')
      end
    end
  end

  describe 'pattern matching' do
    it 'matches on classes' do
      result = case success(42)
               in FFMonads::Result::Success
                 true
               in FFMonads::Result::Failure
                 false
               end

      expect(result).to eql(true)
    end

    context 'matching values' do
      it 'matches successful values' do
        result = case success(42)
                 in FFMonads::Result::Success(Integer => x)
                   x
                 in FFMonads::Result::Failure(String => y)
                   y
                 end

        expect(result).to eql(42)
      end

      it 'matches failed values' do
        result = case failure('foobar')
                 in FFMonads::Result::Success(Integer => x)
                   x
                 in FFMonads::Result::Failure(String => y)
                   y
                 end

        expect(result).to eql('foobar')
      end
    end

    describe 'mixing in Success and Failure' do
      # Note: If add_classes is used in a module_eval block,
      # the resultant constant can't be accessed in functions
      # defined on the module itself.  This is a limitation in
      # Ruby.  For that reason, I'm creating modules in these
      # tests rather than using `Module.new`.
      it 'can use Success' do
        module TestCanUseSuccess
          extend FFMonads::Result::Mixin
          add_classes

          def self.test
            case success(42)
            in Success(Integer => x)
              x
            in Failure(String => y)
              y
            end
          end
        end

        expect(TestCanUseSuccess.test).to eql(42)
      end

      it 'can use Failure' do
        module TestCanUseFailure
          extend FFMonads::Result::Mixin
          add_classes

          def self.test
            case failure('foobar')
            in Success(Integer => x)
              x
            in Failure(String => y)
              y
            end
          end
        end

        expect(TestCanUseFailure.test).to eql('foobar')
      end
    end
  end
end
