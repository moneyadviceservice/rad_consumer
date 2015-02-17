RSpec.describe SearchForm do
  describe 'validation' do
    it 'requires a postcode' do
      expect(described_class.new).to_not be_valid
    end

    it 'requires a correctly formatted postcode' do
      expect(described_class.new(postcode: 'ABC')).to_not be_valid
    end
  end
end
