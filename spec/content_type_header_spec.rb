require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe EmailTest::Headers::ContentType do
  before(:each) do
    @content_type_str = %{Content-Type: multipart/alternative;
     boundary="------------090807010703040106060608"}
    @content_type_with_charset = %{Content-Type: text/plain; charset=ISO-8859-1; format=flowed}
    @content_type = EmailTest::Headers::ContentType.new @content_type_str
  end

  it "extends the base Header class" do
    @content_type.should be_a(EmailTest::Headers::Header)
  end

  it "allows access to attributes as a Hash" do
    @content_type.should respond_to(:attributes)
    @content_type.should_not respond_to(:attributes=)

    @content_type.attributes.should be_a(Hash)
  end

  it "parses a Content-Type with a boundary" do
    @content_type.key.should == "Content-Type"
    @content_type.value.should == "multipart/alternative"
    @content_type.attributes.should == { "boundary" => "------------090807010703040106060608" }
  end

  it "parses a Content-Type with a charset" do
    @content_type = EmailTest::Headers::ContentType.new @content_type_with_charset

    @content_type.key.should == "Content-Type"
    @content_type.value.should == "text/plain"
    @content_type.attributes.should == { "charset" => "ISO-8859-1", "format" => "flowed" }
  end
end

