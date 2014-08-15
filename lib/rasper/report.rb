require 'java'

Rasper::JARLoader.load

java_import Java::net::sf::jasperreports::engine::data::JRXmlDataSource
java_import Java::net::sf::jasperreports::engine::util::FileResolver
java_import Java::net::sf::jasperreports::engine::JasperRunManager
java_import Java::java::io::ByteArrayInputStream
java_import Java::java::io::BufferedInputStream
java_import Java::java::io::FileInputStream
java_import Java::java::util::Locale

require 'active_support/core_ext'

module Rasper
  class Report
    extend Locale

    class << self
      def generate_pdf(jasper_name, data, params = {})
        run_with_locale do
          set_file_resolver(params)
          file_name = File.join(Config.jasper_dir || '.', jasper_name + '.jasper')
          data = { jasper_name => data }.to_xml
          xpath_criteria = "/hash/#{jasper_name}/#{jasper_name.singularize}"
          source = JRXmlDataSource.new(
            ByteArrayInputStream.new(data.to_java_bytes), xpath_criteria)
          input = FileInputStream.new(file_name)
          String.from_java_bytes(
            JasperRunManager.runReportToPdf(input, params, source))
        end
      end

      def generate_html(jasper_name, output_file, data, params = {})
        run_with_locale do
          set_file_resolver(params)
          file_name = File.join(Config.jasper_dir || '.', jasper_name + '.jasper')
          jasper_content = File.read(file_name)
          data = { jasper_name => data }.to_xml
          xpath_criteria = "/hash/#{jasper_name}/#{jasper_name.singularize}"
          source = JRXmlDataSource.new(
            ByteArrayInputStream.new(data.to_java_bytes), xpath_criteria)
          input = file_name.to_java
          JasperRunManager.runReportToHtmlFile(input, output_file.to_java, params, source)
        end
      end

      private

      def set_file_resolver(params)
        resolver = FileResolver.new
        image_directory = Config.image_dir
        resolver.singleton_class.instance_eval do
          define_method :resolve_file do |filename|
            java::io::File.new("#{image_directory}/#{filename}")
          end
        end
        params['REPORT_FILE_RESOLVER'] = resolver
      end
    end
  end
end