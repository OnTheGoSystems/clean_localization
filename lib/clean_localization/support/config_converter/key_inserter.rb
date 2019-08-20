module CleanLocalization
  module Support
    class ConfigConverter
      class KeyInserter
        def self.insert(key, value, res)
          root = res
          key[0..-2].each do |k|
            root[k] ||= {}
            root = root[k]
          end
          root[key.last] = value
        end
      end
    end
  end
end
