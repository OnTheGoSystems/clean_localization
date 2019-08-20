require 'spec_helper'

describe CleanLocalization::Client::JsonData do
  let(:lang) { 'en' }

  let(:data) do
    {
      layout: {
        button: {
          en: 'Button',
          uk: 'Батон'
        },
        label: {
          en: 'Label'
        }
      },
      jobs: {
        index: {
          fr: 'Mes emplois',
          en: 'My Jobs',
          uk: 'Мої джоби'
        }
      }
    }.deep_stringify_keys
  end

  let(:instance) { described_class.new(lang, data) }

  describe '#build_hash' do
    subject { instance.build_hash }

    let(:result) do
      {
        'layout.button' => 'Button',
        'layout.label' => 'Label',
        'jobs.index' => 'My Jobs'
      }
    end

    it { is_expected.to eq result }

    context 'when uk' do
      let(:lang) { 'uk' }

      let(:result) do
        {
          'layout.button' => 'Батон',
          'layout.label' => 'Label',
          'jobs.index' => 'Мої джоби'
        }
      end

      it { is_expected.to eq result }
    end

    context 'when fr' do
      let(:lang) { 'fr' }

      let(:result) do
        {
          'layout.button' => 'Button',
          'layout.label' => 'Label',
          'jobs.index' => 'Mes emplois'
        }
      end

      it { is_expected.to eq result }
    end
  end
end
