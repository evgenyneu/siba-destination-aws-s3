# encoding: UTF-8

require 'helper/require_unit'
require 'siba-destination-aws-s3/init'

describe Siba::Destination::AwsS3::Init do
  before do                    
    @obj = Siba::Destination::AwsS3::Init
    @yml_path = File.expand_path('../yml', __FILE__)
    @options_hash = load_options "valid" 
  end

  it "should load plugin" do
    plugin = @obj.new @options_hash
    plugin.must_be_instance_of Siba::Destination::AwsS3::Init
    plugin.cloud.must_be_instance_of Siba::Destination::AwsS3::Cloud
  end
  
  it "should fail when options are missing" do
    ->{@obj.new({})}.must_raise Siba::CheckError
    ->{@obj.new({"bucket"=>"value"})}.must_raise Siba::CheckError
    ->{@obj.new({"bucket"=>"value", "secret_key"=>"value"})}.must_raise Siba::CheckError
    ->{@obj.new({"bucket"=>"value", "access_key_id"=>"value"})}.must_raise Siba::CheckError
  end

  it "should run backup" do
    plugin = @obj.new @options_hash
    plugin.backup "/file"
  end
end
