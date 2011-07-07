module EmailTest
  require 'email_test/header'
  # Require each header extension
  Dir["#{File.dirname(__FILE__)}/headers/*.rb"].each do|h| 
    require "email_test/headers/#{File.basename(h)}"
  end

  ##
  # Main entry point class to the lib. Encapsulates a single message from an
  # email thread. Instantiation takes a raw email string, but more likely the
  # user will be using the {.parse_thread} class-level method to return an
  # array of parsed messages.
  #
  # @author Josh Lindsey
  #
  class Email
    # Lambda to convert header string keys into symbols.
    # Used in {#method_missing} and {#respond_to?}.
    ConvertKey = ->(h){ h.key.downcase.gsub('-', '_').to_sym }

    # The default email boundary is just an empty line
    @@boundary = /^\s?$/

    ## @return [String] The raw email string before parsing
    attr_reader :raw

    ## @return [Array] The parsed headers
    attr_reader :headers
    
    ## @return [String] The parsed email body
    attr_reader :body

    ##
    # Parse the input string and return a new {Email} object.
    #
    # @param [String] raw_str The raw email input
    # 
    # @see {#parse_headers!}
    # @see {#parse_body!}
    #
    # @author Josh Lindsey
    def initialize raw_str
      @raw = raw_str
      @headers = []

      parse_headers!
      parse_body!
    end

    ##
    # Override method_missing to allow us to access headers as methods.
    #
    # @param [Symbol] sym The method symbol
    # @param [*Array] args The splatted array of method arguments passed in
    #
    # @author Josh Lindsey
    def method_missing sym, *args
      if @headers.map { |h| ConvertKey.call(h) }.include? sym
        return @headers.find { |h| ConvertKey.call(h) == sym }.value
      else
        super
      end
    end

    ##
    # Override respond_to? to properly correspond to our {#method_missing},
    # returning true for any method that corresponds to a header.
    #
    # @param [Symbol] sym The method symbol
    #
    # @author Josh Lindsey
    def respond_to? sym
     if @headers.map { |h| ConvertKey.call(h) }.include? sym
       true
     else
       super
     end
    end

    private

    ##
    # Does the actual parsing heavy lifting.
    #
    # @TODO This will most likely work better and faster with a
    #       readahead regex, but doing it this way is easier to
    #       write quickly and more readable.
    #
    # @author Josh Lindsey
    def parse_headers!
      buffer = ''

      @raw.each_line do |line|
        # Break out of parsing headers if we hit the boundary
        if (@@boundary.is_a?(::Regexp) and line =~ @@boundary) or
           (@@boundary.is_a?(::String) and line == @@boundary)
          @headers << parse_header(buffer.dup)
          break
        end

        # Properly handle multiline headers. Assume that a line that is indented is a
        # continuation of the current header.
        if line =~ /^\s+/ or buffer.empty?
          buffer << line
        else
          # TODO: add in a Content-Type boundary check here and change the @@boundary var
          @headers << parse_header(buffer.dup)
          buffer.clear
          buffer << line
        end
      end
    end

    ##
    # Parse the body out of the raw email text. Essentially grabs an offset until the end.
    # Should do something more complex when the Content-Type is multipart.
    #
    # @author Josh Lindsey
    def parse_body!
      offset = nil

      if @@boundary.is_a?(::String)
        offset = @raw.index @@boundary
      else
        offset = @raw =~ @@boundary
      end

      raise "Unable to parse email body" if offset.nil? or offset <= 0

      @body = @raw[offset..-1].strip
    end

    ##
    # Parses and returns the correct Header instance for this header string.
    # First simply instantiates a [Header] object, using it to parse the string,
    # then checks to see if there's a specific header parser defined for this 
    # header and uses that instead.
    #
    # @param [String] header_str The header string to parse
    #
    # @return [EmailTest::Header] Either the {Header} instance, or some instance that extends it
    def parse_header header_str
      parsed = Headers::Header.new header_str
      class_name = get_class_name_from_key parsed.key

      if EmailTest::Headers.constants.include? class_name
        header_parser = EmailTest::Headers.const_get class_name
        parsed = header_parser.new header_str
      end

      parsed
    end

    ##
    # Parse and return the class convention name for a Header key.
    #
    # @param [String] key The Header key
    # @return [Symbol] The capitalized class name
    def get_class_name_from_key key
      key.split('-').map(&:capitalize).join.to_sym
    end
  end
end

