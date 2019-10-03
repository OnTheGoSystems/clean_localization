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
      @json_data ||= JsonData.new(@language, self.class.data).render
    end

    class << self
      attr_writer :data

      def data
        @data ||= reload_data!
      end

      def reload_data!
        @data = CleanLocalization::Config.load_data.freeze
      end
    end

    private

    def fetch_translation(key)
      key_nodes = key.split('.')
      key_nodes << @language.to_s

      value = self.class.data

      key_nodes.each do |k|
        return fallback(k, value) unless value[k]

        value = value[k]
      end

      value.freeze
    end

    def fallback(key, data)
      data.is_a?(Hash) && data[key]
    end

    def insert_variables!(value, variables)
      return value if variables.empty?
      translation = value.dup
      variables.each { |k, v| translation.gsub!("%{#{k}}", v) }
      translation
    end
  end
end
