require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe EmailTest::Email do
  before(:each) do
    @simple_message = File.read(File.join(EmailsDir, 'simple_message.txt')).strip
    @email = EmailTest::Email.new @simple_message
  end

  it "implements the #parse_headers! private method" do
    @email.private_methods.should include(:parse_headers!)
  end

  it "implements the #parse_body! private method" do
    @email.private_methods.should include(:parse_body!)
  end
  
  it "raises an exception on an unparseable email" do
    -> { EmailTest::Email.new '' }.should raise_exception(RuntimeError) do |e|
      e.message.should include("Unable to parse email")
    end
  end

  it "makes the raw email text available as a read-only member" do
    @email.should respond_to(:raw)
    @email.should_not respond_to(:raw=)
    
    @email.raw.should be_a(String)
    @email.raw.should == @simple_message
  end

  it "makes the email headers available as a read-only array with the parsed headers" do
    @email.should respond_to(:headers)
    @email.should_not respond_to(:headers=)

    @email.headers.should be_an(Array)
  end

  it "makes the email body available as a read-only member" do
    @email.should respond_to(:body)
    @email.should_not respond_to(:body=)

    @email.body.should be_a(String)
    @email.body.should == "CRITICAL - load average: 18.01, 17.73, 17.38"
  end

  it "overrides #method_missing to get an email header by name" do
   @email.should respond_to(:method_missing)
   -> { @email.to }.should_not raise_exception(NoMethodError)
   -> { @email.subject }.should_not raise_exception(NoMethodError)

   @email.to.should == "josh@cloudspace.com"
   @email.subject.should == "chsfirst.org Load Average CRITICAL!"
  end

  it "overrides #responds_to? to respond properly to #method_missing" do
    @email.should respond_to(:to)
    @email.should respond_to(:subject)
    @email.should respond_to(:return_path)
    @email.should respond_to(:content_type)
  end

  it "detects and creates the specific header class correctly for Content-Type" do
    @email.headers.find { |h| h.key == "Content-Type" }.should \
      be_a(EmailTest::Headers::ContentType)
  end

  it "changes the @boundary variable when a Content-Type with a boundary is parsed" do
    email = EmailTest::Email.new File.read(File.join(EmailsDir, 'otf_thread.txt')).strip
    email.instance_variable_get(:@boundary).should == "--------------090807010703040106060608"
  end

  it "changes the @body instance var to an array of multi body parts when the content type is multipart" do
    email = EmailTest::Email.new File.read(File.join(EmailsDir, 'otf_thread.txt')).strip
    email.body.should be_an(Array)
    email.body.each do |b|
      b.should be_a(EmailTest::Email)
    end
  end
end

