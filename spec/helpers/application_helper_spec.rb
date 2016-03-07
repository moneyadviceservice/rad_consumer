require 'spec_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#feature_enabled?' do
    context 'when environement variable set to true' do
      it 'is enabled' do
        ENV['TEST_FEATURE_FLAG'] = 'true'
        expect(helper.feature_enabled?('TEST_FEATURE_FLAG')).to eql(true)
      end
    end

    context 'when environement variable set to false' do
      it 'is disabled' do
        ENV['TEST_FEATURE_FLAG'] = 'false'
        expect(helper.feature_enabled?('TEST_FEATURE_FLAG')).to eql(false)
      end
    end

    context 'when environement variable is missing' do
      it 'is disabled' do
        ENV['TEST_FEATURE_FLAG'] = nil
        expect(helper.feature_enabled?('TEST_FEATURE_FLAG')).to eql(false)
      end
    end
  end
end
