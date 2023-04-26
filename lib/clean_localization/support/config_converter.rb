module CleanLocalization
  module Support
    class ConfigConverter
      def clean_to_i18n(clean_config, ignore_translated: false)
        CleanToI18n.new(ignore_translated: ignore_translated).convert(clean_config)
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

      def build_full_i18n_tree(translated_dir_path)
        paths = CleanLocalization::Config.file_paths(translated_dir_path)
        hashes = paths.map { |p| CleanLocalization::Config.load_yaml(p) }
        all = {}
        hashes.each { |h| all.deep_merge!(h) }
        all
      end

      def apply_all_i18n(translated_dir_path, main_dir_path = CleanLocalization::Config.base_path.to_s, persist=true)
        main_dir_path = Pathname(main_dir_path) if main_dir_path.is_a?(String)
        translated_dir_path = Pathname(translated_dir_path) if translated_dir_path.is_a?(String)

        full_translated_tree = build_full_i18n_tree(translated_dir_path)

        updates = CleanLocalization::Config.file_paths(main_dir_path).map do |original_path|
          original_yaml = CleanLocalization::Config.load_yaml(original_path)

          primary_key_paths = []
          deep_primary_key(original_yaml) { |full_key| primary_key_paths << full_key }

          primary_key_paths.map do |fk|
            apply_locales(full_translated_tree, fk, original_yaml)
          end

          dump_yaml(original_yaml, original_path) if persist
          { original_path: original_path, updated: original_yaml }
        end

        updates
      end

      def apply_locales(full_translated_tree, full_key, original_yaml)
        full_translated_tree.keys.each do |locale|
          value = full_translated_tree[locale]
          full_key.each do |kp|
            break if value.nil?

            if value.is_a?(Hash)
              value = value[kp]
            end
          end

          next if value.nil?

          original_value = original_yaml
          full_key.each { |kp| original_value = original_value[kp] }
          original_value[locale] = value
        end
      end

      def deep_primary_key(value, key_path=[], &block)
        if value.is_a?(Hash)
          if value.keys.include?(CleanLocalization::Client::JsonData::PRIMARY_LOCALE)
            yield(key_path)
          else
            value.keys.each { |k| deep_primary_key(value[k], key_path.dup.concat([k]), &block) }
          end
        end
      end

      def dump_yaml(hash, path)
        File.open(path, 'w') { |f| f.write hash.to_yaml }
      end
    end
  end
end
