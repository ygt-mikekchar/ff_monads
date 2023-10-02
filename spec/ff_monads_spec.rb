# frozen_string_literal: true

require_relative '../lib/ff_monads'

RSpec.describe FFMonads do
  describe 'Mixin with extend' do
    module ModuleFoo
      extend FFMonads
    end

    it 'does something' do
      expect(ModuleFoo.some(42).to_s).to eql('some(42)')
    end
  end

  describe 'Mixin with include' do
    class ClassFoo
      include FFMonads

      def some_forty_two
        some(42)
      end
    end

    it 'does something' do
      expect(ClassFoo.new.some_forty_two.to_s).to eql('some(42)')
    end
  end
end
