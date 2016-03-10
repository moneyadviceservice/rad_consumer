RSpec.describe Geocode do
  class ExampleResult
    attr_accessor :distance
    attr_reader :name, :location

    def initialize(name, lat, lon)
      @name = name
      @location = Location.new(lat, lon)
    end
  end

  describe 'by_location' do
    let(:latitude) { 50.123456 }
    let(:initial_location) { [latitude, -0.000001] }

    let(:results) do
      [
        ExampleResult.new('A', latitude, -0.100001),
        ExampleResult.new('B', latitude, -0.500001),
        ExampleResult.new('C', latitude, -0.300001),
        ExampleResult.new('D', latitude, -0.40001)
      ]
    end

    it 'returns the objects ordered by location' do
      sorted_names = Geosort.by_distance(initial_location, results).map(&:name)
      expect(sorted_names).to eq(%w(A C D B))
    end
  end
end
