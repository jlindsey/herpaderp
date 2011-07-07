require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe EmailTest::Headers::Header do
  before(:each) do
    @header_str = "Subject: chsfirst.org Load Average CRITICAL!"
    @bad_header = "Hello there this is a bad header"
    @header = EmailTest::Headers::Header.new @header_str
  end

  it "implements the #parse! private method" do
    @header.private_methods.should include(:parse!)
  end

  it "makes the raw header available as a read-only member" do
    @header.should respond_to(:raw)
    @header.should_not respond_to(:raw=)

    @header.raw.should be_a(String)
    @header.raw.should == @header_str
  end

  it "makes the header key available as a read-only member" do
    @header.should respond_to(:key)
    @header.should_not respond_to(:key=)

    @header.key.should be_a(String)
    @header.key.should == "Subject"
  end

  it "makes the header value available as a read-only member" do
    @header.should respond_to(:value)
    @header.should_not respond_to(:value=)

    @header.value.should be_a(String)
    @header.value.should == "chsfirst.org Load Average CRITICAL!"
  end

  it "raises an exception when it's unable to parse a header string" do
    -> { EmailTest::Headers::Header.new @bad_header }.should raise_exception(RuntimeError) do |e|
      e.message.should == "Unable to parse Header: #{@bad_header}"
    end
  end
end

