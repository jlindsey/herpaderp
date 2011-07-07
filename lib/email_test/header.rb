module EmailTest
  module Headers

    ##
    # Base header parsing and encapsulation class. All specific header parsers extend
    # this class, but this isn't a true abstract class. If there's no specific parser
    # for a certain header, this class will be used instead.
    #
    # @author Josh Lindsey
    class Header
      ## @return [String] The raw header value
      attr_reader :raw

      ## @return [String] The header key
      attr_reader :key

      ## @return [String] The header value
      attr_reader :value

      ##
      # Parses and returns a new Header object.
      # 
      # @param [String] raw_header The raw header line.
      #
      # @see {#parse!}
      # @see {EmailTest::Email#parse!}
      #
      # @author Josh Lindsey
      def initialize raw_header
        @raw = raw_header
        parse!
      end

      private

      ##
      # Parses the raw header string into its component parts. This base
      # implementation is very simple, just parsing out the key and value.
      #
      # @author Josh Lindsey
      def parse!
        if /^(?<key>.*?):(?<value>.*)/m =~ @raw
          @key = key.strip
          @value = value.strip
        else
          raise "Unable to parse Header: #{@raw}"
        end
      end
    end
  end
end
