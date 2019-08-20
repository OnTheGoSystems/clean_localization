module CleanLocalization
  class Config
    class << self
      def load_data
        files.each_with_object({}) { |h, r| r.deep_merge!(h) }
      end

      def files
        file_paths.map { |f| load_yaml(f) }
      end

      def load_yaml(path)
        YAML.safe_load(File.read(path))
      end

      def file_paths
        Dir.open(base_path).select { |x| x.end_with?('.yml') }.map do |f|
          base_path.join(f).to_s
        end
      end

      def base_path
        @base_path
      end

      def base_path=(path)
        @base_path = path
      end
    end
  end
end
