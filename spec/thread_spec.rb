require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe EmailTest::Thread do
  # NOTE: These specs are all just stubs to demonstrate a way in which this lib could
  #       be improved

  it "makes available a read-only representation of the top-level thread headers"
  it "makes available a read-only array of Emails"
  it "responds to the .parse_thread class method to parse a raw email thread string"
  it "includes Enumberable"
end

