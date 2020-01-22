require_relative './config'
require_relative './client/json_data'
require_relative './support/config_converter/clean_to_i18n'
require_relative './support/config_converter/i18n_to_clean'
require_relative './support/config_converter/key_inserter'
require_relative './support/config_converter'

module CleanLocalization
  class Client
    def initialize(locale = Config.current_locale)
      @locale = locale
    end

    def translate(key, arguments = {})
      value = fetch_translation(key)
      insert_variables!(value, arguments)
    end

    def json_data
      @json_data ||= JsonData.new(@locale, self.class.data).render
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
      key_nodes << @locale.to_s

      value = self.class.data

      key_nodes.each do |k|
        return fallback(value) unless value[k]

        value = value[k]
      end

      value
    end

    def fallback(data)
      res = data.is_a?(Hash) && data['en']
      res.is_a?(String) ? res : nil
    end

    def insert_variables!(value, variables)
      return value&.dup if variables.empty?
      translation = value.dup
      variables.each { |k, v| translation.gsub!("%{#{k}}", v.to_s) }
      translation
    end
  end
end
