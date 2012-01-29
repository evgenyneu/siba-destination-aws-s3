# encoding: UTF-8

require 'helper/require_unit'
require 'siba-destination-aws-s3/init'

describe Siba::Destination::AwsS3::Init do
  before do                    
    @obj = Siba::Destination::AwsS3::Init
    @yml_path = File.expand_path('../yml', __FILE__)
    @options_hash = load_options "valid" 
    @plugin = @obj.new @options_hash
  end

  it "should load plugin" do
    @plugin.must_be_instance_of Siba::Destination::AwsS3::Init
    @plugin.cloud.must_be_instance_of Siba::Destination::AwsS3::Cloud
  end

  it "should not fail if keys are missing but env variables are defined" do
    ENV[@obj::DEFAULT_ACCESS_KEY_ID_ENV_NAME] = "akd"
    ENV[@obj::DEFAULT_SECRET_KEY_ENV_NAME] = "sk"
    cloud = @obj.new({"bucket"=>"bucket"})
    cloud.cloud.access_key_id.must_equal "akd"
    cloud.cloud.secret_key.must_equal "sk"
  end

  it "should fail if keys are missing" do
    ENV[@obj::DEFAULT_ACCESS_KEY_ID_ENV_NAME] = nil
    ENV[@obj::DEFAULT_SECRET_KEY_ENV_NAME] = "sk"
    ->{@obj.new({"bucket"=>"bucket"})}.must_raise Siba::CheckError

    ENV[@obj::DEFAULT_ACCESS_KEY_ID_ENV_NAME] = "akd"
    ENV[@obj::DEFAULT_SECRET_KEY_ENV_NAME] = nil
    ->{@obj.new({"bucket"=>"bucket"})}.must_raise Siba::CheckError
  end
  
  it "should fail when bucket is missing" do
    ->{@obj.new({})}.must_raise Siba::CheckError
    ->{@obj.new({"secret_key"=>"value"})}.must_raise Siba::CheckError
    ->{@obj.new({"access_key_id"=>"value"})}.must_raise Siba::CheckError
  end

  it "should run backup" do
    @plugin.backup "/file"
  end
  
  it "should run get_backups_list" do
    @plugin.get_backups_list "/file"
  end

  it "should run restore" do
    @plugin.restore "backup_name", "/dir"
  end
end
