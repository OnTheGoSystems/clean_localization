# frozen_string_literal: true

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

  context do
    let(:translated_path) do
      CleanLocalization::Config.base_path.join('converter/translated')
    end

    let(:original_path) do
      CleanLocalization::Config.base_path.join('converter/original')
    end

    context '#build_full_i18n_tree' do
      subject { converter.build_full_i18n_tree(translated_path) }

      let(:full_tree) do
        {
          'dogs' => {
            'like_barking' => { 'en' => 'I like barking' }
          },
          'cats' => {
            'like_fish' => { 'en' => 'I like fish', 'uk' => 'Я люблю рибу' },
            'hunt_mouse' => { 'en' => 'I hunt mouse' }
          }
        }
      end

      it do
        is_expected.to eq full_tree
      end
    end
  end
end
