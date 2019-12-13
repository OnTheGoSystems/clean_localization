module CleanLocalization
  class Config
    class << self
      DEFAULT_LOCALE = :en

      attr_writer :current_locale

      def load_data
        files.each_with_object({}) { |h, r| r.deep_merge!(h) }
      end

      def files
        file_paths.map { |f| load_yaml(f) }
      end

      def load_yaml(path)
        YAML.safe_load(File.read(path))
      end

      def file_paths(path = base_path)
        Dir.open(path).select { |x| x.end_with?('.yml') }.map do |f|
          path.join(f).to_s
        end
      end

      def base_path
        @base_path
      end

      def base_path=(path)
        @base_path = path
      end

      def current_locale
        @current_locale || DEFAULT_LOCALE
      end

    end
  end
end
