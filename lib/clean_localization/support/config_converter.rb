module CleanLocalization
  module Support
    class ConfigConverter
      def clean_to_i18n(clean_config)
        CleanToI18n.new.convert(clean_config)
      end

      def i18n_to_clean(i18n_config)
        I18nToClean.new.convert(i18n_config)
      end

      def convert_all_to_18n
        CleanLocalization::Config.file_paths.each do |original_path|
          parts = original_path.split('/')
          parts[-1] = "i18n/#{parts.last}"
          output_path = parts.join('/')
          yml = CleanLocalization::Config.load_yaml(original_path)
          converted_yml = clean_to_i18n(yml)
          puts "converted: #{output_path}"
          dump_yaml(converted_yml, output_path)
        end
      end

      def apply_i18n(original_clean_path, translated_18n_path)
        cc = CleanLocalization::Support::ConfigConverter.new
        original = CleanLocalization::Config.load_yaml(original_clean_path)
        target = CleanLocalization::Config.load_yaml(translated_18n_path)
        updated_original = original.deep_merge(cc.i18n_to_clean(target))
        cc.dump_yaml(updated_original, original_clean_path)
      end

      def apply_all_i18n(translated_dir_path)
        CleanLocalization::Config.file_paths.each do |original_path|
          filepath = original_path.gsub(CleanLocalization::Config.base_path.to_s, '')
          translated_path = translated_dir_path + filepath
          apply_i18n(original_path, translated_path)
        end
      end

      def dump_yaml(hash, path)
        File.open(path, 'w') { |f| f.write hash.to_yaml }
      end
    end
  end
end
