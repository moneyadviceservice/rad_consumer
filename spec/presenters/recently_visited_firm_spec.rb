RSpec.describe RecentlyVisitedFirm do
  let(:recently_visited_firm) do
    RecentlyVisitedFirm.new(
      profile_path: {
        'en' => '/en/firms/3866',
        'cy' => '/cy/firms/3866'
      }
    )
  end

  describe '#translated_profile_path' do
    subject { recently_visited_firm.translated_profile_path }

    context 'when english' do
      before { expect(I18n).to receive(:locale).and_return('en') }

      it 'returns english profile path' do
        expect(subject).to eq('/en/firms/3866')
      end
    end

    context 'when welsh' do
      before { expect(I18n).to receive(:locale).and_return('cy') }

      it 'returns welsh profile path' do
        expect(subject).to eq('/cy/firms/3866')
      end
    end
  end

  describe '#closest_adviser?' do
    subject { recently_visited_firm.closest_adviser? }

    context 'when is face to face' do
      before do
        expect(recently_visited_firm).to receive(:face_to_face?).and_return(true)
      end

      context 'when has closest adviser (user searched by location)' do
        before do
          expect(recently_visited_firm).to receive(:closest_adviser_distance).and_return(0.34)
        end

        it 'returns true' do
          expect(subject).to be(true)
        end
      end

      context 'when does not have closest adviser (user searched by name)' do
        before do
          expect(recently_visited_firm).to receive(:closest_adviser_distance).and_return(nil)
        end

        it 'returns false' do
          expect(subject).to be(false)
        end
      end
    end

    context 'when is not face to face' do
      before do
        expect(recently_visited_firm).to receive(:face_to_face?).and_return(false)
      end

      it 'returns false' do
        expect(subject).to be(false)
      end
    end
  end

  describe '#phone_or_online_only?' do
    subject { recently_visited_firm.phone_or_online_only? }

    context 'when is face to face' do
      before do
        expect(recently_visited_firm).to receive(:face_to_face?).and_return(true)
      end

      it 'returns false' do
        expect(subject).to be(false)
      end
    end

    context 'when is not face to face' do
      before do
        expect(recently_visited_firm).to receive(:face_to_face?).and_return(false)
      end

      it 'returns true' do
        expect(subject).to be(true)
      end
    end
  end
end
