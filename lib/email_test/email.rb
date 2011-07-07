module EmailTest

  ##
  # Main entry point class to the lib. Encapsulates a single message from an
  # email thread. Instantiation takes a raw email string, but more likely the
  # user will be using the {.parse_thread} class-level method to return an
  # array of parsed messages.
  #
  # @author Josh Lindsey
  #
  class Email
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
    # @see {#parse!}
    #
    # @author Josh Lindsey
    def initialize raw_str
      @raw = raw_str
      parse!
    end


    private

    ##
    # Does the actual parsing heavy lifting.
    #
    # @author Josh Lindsey
    def parse!
      
    end
  end
end

