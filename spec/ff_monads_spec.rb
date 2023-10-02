require 'ff_monads'

RSpec.describe FFMonads do
  describe 'foo' do
    it 'returns bar' do
      expect(FFMonads.foo).to eql('bar')
    end
  end
end
