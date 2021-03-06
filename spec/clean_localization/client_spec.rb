require 'spec_helper'

describe CleanLocalization::Client do
  let(:client) { described_class.new }

  describe '.data' do
    it 'loads data only once, caching it' do
      expect(CleanLocalization::Config)
        .to receive(:load_data)
        .and_return({})
        .once

      expect(described_class.data).to eq({})
      expect(described_class.data).to eq({})
    end
  end

  describe '.reload_data!' do
    it 'reloads data into `data`' do
      pre_data = CleanLocalization::Client.data # ensure data is loaded
      reload = lambda do
        CleanLocalization::Config.base_path = Dir.mktmpdir
        described_class.reload_data!
      end

      expect(&reload)
        .to change(described_class, :data)
        .from(pre_data)
        .to({})
    end
  end

  describe '#translate' do
    let(:key) { 'layout.login.button' }
    subject { client.translate(key) }

    context 'when `en` exists as a key' do
      context 'and key exists' do
        let(:key) { 'languages.nl' }

        it { is_expected.to eq 'Dutch' }
      end

      context 'and key does not exist' do
        let(:key) { 'languages.jp' }

        it { is_expected.to eq nil }
      end
    end

    context 'when valid key & lang' do
      it { is_expected.to eq 'Sign in!' }
    end

    context 'when non existing locale' do
      let(:client) { described_class.new('nn') }
      it { is_expected.to eq 'Sign in!' }
    end

    context 'when uk' do
      let(:client) { described_class.new('uk') }
      it { is_expected.to eq 'Увійти' }
    end

    context 'when non-existing key' do
      let(:key) { 'layout.login.non_label' }

      it { is_expected.to eq nil }
    end

    context 'when with variables' do
      let(:key) { 'layout.signed_as' }

      subject { client.translate(key, login: 'Jon Snow') }

      it { is_expected.to eq 'Signed as <strong>Jon Snow</strong>' }
    end

    context 'when multiple calls' do
      let(:key) { 'layout.signed_as' }

      let(:t){ ->(name) { client.translate(key, login: name) }  }

      it do
        expect(t.call('Jon Snow')).to eq 'Signed as <strong>Jon Snow</strong>'
        expect(t.call('Night King')).to eq 'Signed as <strong>Night King</strong>'
      end
    end
  end

  describe '#insert_variables!' do
    let(:translation) { 'Hello %{name}!' }

    subject { client.send(:insert_variables!, translation, name: 'World') }

    it { is_expected.to eq 'Hello World!' }
  end

  describe '#json_data' do
    subject { client.json_data }

    it { is_expected.to be_a String }
  end
end
