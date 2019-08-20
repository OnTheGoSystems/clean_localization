module CleanLocalization
  module Support
    class ConfigConverter
      class I18nToClean
        def convert(clean_config)
          res = {}
          build_clean_record(clean_config, [], res)
          res
        end

        private

        def build_clean_record(hash, key, res)
          if !hash.is_a?(Hash)
            value = hash
            final_key = key.dup
            final_key << final_key.shift
            KeyInserter.insert(final_key, value, res)
          else
            hash.each do |cur_key, next_hash|
              next_key = key.dup
              next_key << cur_key
              build_clean_record(next_hash, next_key, res)
            end
          end
        end
      end
    end
  end
end
