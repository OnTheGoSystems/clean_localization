require 'spec_helper'

describe CleanLocalization::Support::ConfigConverter do
  let(:converter) { described_class.new }

  let(:clean_config) do
    {
      my: {
        good: {
          key: {
            en: 'Value',
            uk: 'Значення'
          }
        }
      }
    }.deep_stringify_keys
  end

  let(:i18n_config) do
    {
      en: {
        my: {
          good: {
            key: 'Value'
          }
        }
      },
      uk: {
        my: {
          good: {
            key: 'Значення'
          }
        }
      }
    }.deep_stringify_keys
  end

  context '#clean_to_i18n' do
    subject { converter.clean_to_i18n(clean_config) }

    it { is_expected.to eq i18n_config }
  end

  context '#i18n_to_clean' do
    subject { converter.i18n_to_clean(i18n_config) }

    it { is_expected.to eq clean_config }
  end
end
