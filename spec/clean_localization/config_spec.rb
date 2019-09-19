require 'spec_helper'

describe CleanLocalization::Config do
  describe '.load_data' do
    subject { described_class.load_data }

    it { is_expected.to be_a(Hash) }
    it { expect(subject.keys).to match_array %w(dashboard layout cms instant_translation v2 messages languages) }
  end
end
