require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe EmailTest::Email do
  before(:each) do
    @simple_message = File.read(File.join(EmailsDir, 'simple_message.txt'))
    @email = EmailTest::Email.new @simple_message
  end

  it "should implement the #parse! private method" do
    @email.private_methods.should include(:parse!)
  end
  
  it "should raise an exception on an unparseable email" do
    lambda { EmailTest::Email.new '' }.should raise_exception(RuntimeError) do |e|
      e.message.should include("Unable to parse email")
    end
  end

  it "should make the raw email text available as a read-only member" do
    @email.should respond_to(:raw)
    @email.should_not respond_to(:raw=)
    
    @email.raw.should be_a(String)
    @email.raw.should == @simple_message
  end

  it "should make the email headers available as a read-only array with the parsed headers" do
    @email.should respond_to(:headers)
    @email.should_not respond_to(:headers=)

    @email.headers.should be_an(Array)
  end

  it "should make the email body available as a read-only member" do
    @email.should respond_to(:body)
    @email.should_not respond_to(:body=)

    @email.body.should be_a(String)
    @email.body.should == "CRITICAL - load average: 18.01, 17.73, 17.38"
  end
end

