RSpec.describe SearchForm do
  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(described_class.new(postcode: 'RG2 1AA')).to be_valid
    end

    it 'requires a postcode' do
      expect(described_class.new).to_not be_valid
    end

    it 'requires a correctly formatted postcode' do
      expect(described_class.new(postcode: 'ABC')).to_not be_valid
    end
  end
end
