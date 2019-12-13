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
          'uk' => {
            'dogs' => { 'like_barking' => 'Я люблю гавкати' }
          },
          'fr' =>
            {
              'dogs' => { 'like_barking' => "J'aime aboyer" },
              'cats' => { 'like_fish' => "J'aime le poisson", 'hunt_mouse' => 'Je chasse la souris' }
            }
        }
      end

      it do
        is_expected.to eq full_tree
      end
    end

    context '#apply_all_i18n' do
      subject { converter.apply_all_i18n(translated_path, original_path, false) }

      let(:all_updates) do
        [
          {
            original_path: CleanLocalization::Config.base_path.join('converter/original/dogs.yml').to_s,
            updated: {
              'dogs' =>
                 {
                   'like_barking' => {
                     'en' => 'I like barking',
                     'uk' => 'Я люблю гавкати',
                     'fr' => "J'aime aboyer"
                   }
                 }
            }
          },
          {
            original_path: CleanLocalization::Config.base_path.join('converter/original/cats.yml').to_s,
            updated: {
              'cats' =>
                 {
                   'like_fish' => {
                     'en' => 'I like fish', 'uk' => 'Я люблю рибу', 'fr' => "J'aime le poisson"
                   },
                   'hunt_mouse' => {
                     'en' => 'I hunt mouse', 'fr' => 'Je chasse la souris'
                   }
                 }
            }
          }
        ]
      end

      it do
        is_expected.to eq all_updates
      end
    end
  end
end
