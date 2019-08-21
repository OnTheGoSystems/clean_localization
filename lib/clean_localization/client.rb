require_relative './config'
require_relative './client/json_data'
require_relative './support/config_converter/clean_to_i18n'
require_relative './support/config_converter/i18n_to_clean'
require_relative './support/config_converter/key_inserter'
require_relative './support/config_converter'

module CleanLocalization
  class Client
    def initialize(language)
      @language = language
    end

    def translate(key, arguments = {})
      value = fetch_translation(key)
      insert_variables!(value, arguments)
    end

    def json_data
      JsonData.new(@language, self.class.data).render
    end

    class << self
      def data
        @data ||= CleanLocalization::Config.load_data
      end
    end

    private

    def fetch_translation(key)
      key_nodes = key.split('.')
      key_nodes << @language.to_s

      value = self.class.data

      key_nodes.each do |k|
        return value['en'] unless value[k]

        value = value[k]
      end

      value
    end

    def insert_variables!(translation, variables)
      variables.each { |k, v| translation.gsub!("%{#{k}}", v) }
      translation
    end
  end
end