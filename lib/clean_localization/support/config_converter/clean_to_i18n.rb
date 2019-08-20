module CleanLocalization
  module Support
    class ConfigConverter
      class CleanToI18n
        def convert(clean_config)
          res = {}
          build_i18n_record(clean_config, [], res)
          res
        end

        private

        def build_i18n_record(hash, key, res)
          if !hash.is_a?(Hash)
            value = hash
            final_key = key.dup
            final_key.unshift(final_key.pop)
            KeyInserter.insert(final_key, value, res)
          else
            hash.each do |cur_key, next_hash|
              next_key = key.dup
              next_key << cur_key
              build_i18n_record(next_hash, next_key, res)
            end
          end
        end
      end
    end
  end
end
