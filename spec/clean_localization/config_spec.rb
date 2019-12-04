require 'spec_helper'

describe CleanLocalization::Config do
  describe '.load_data' do
    subject { described_class.load_data }

    it { is_expected.to be_a(Hash) }
    it { expect(subject.keys).to match_array %w(dashboard layout cms instant_translation v2 messages languages) }
  end

  describe '.current_locale' do
    it 'defaults to en' do
      expect(CleanLocalization::Config.current_locale).to eq :en
    end

    it 'can be changed' do
      expect { CleanLocalization::Config.current_locale = :de }
        .to change(CleanLocalization::Config, :current_locale)
        .from(:en)
        .to(:de)
    end
  end
end
