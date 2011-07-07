module EmailTest
  module Headers

    ##
    # Parses and encapsulates the Content-Type header.
    #
    # @author Josh Lindsey
    class ContentType < Headers::Header
      ## @return [Hash] The parsed attributes for this Content-Type
      attr_reader :attributes
      
      ##
      # Parses and returns a new ContentType encapsulation.
      # 
      # (see EmailTest::Headers::Header#initialize)
      #
      # @author Josh Lindsey
      def initialize raw_header
        super

        @attributes = {}
        parse_attributes!
      end

      private

      ##
      # Parses the attributes out of the {#value} and puts them in the {#attributes} hash.
      #
      # @author Josh Lindsey
      def parse_attributes!
        parts = @value.split(';')
        @value = parts.shift.strip

        parts.each do |part|
          part.strip!
          k,v = part.split('=')
          @attributes[k] = v.gsub('"', '') # remove quotes from eg. boundary attr
        end
      end
    end
  end
end

