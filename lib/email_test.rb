require 'logger'

module EmailTest
  @@logger = nil
  LogFile = File.expand_path('log/email_test.log', File.dirname(__FILE__))
  LogLevel = Logger::INFO

  def self.logger
    if @@logger.nil?
      require 'fileutils'
      FileUtils.mkpath File.dirname(LogFile)

      @@logger = Logger.new LogFile
      @@logger.level = LogLevel
    end

    @@logger
  end
end

