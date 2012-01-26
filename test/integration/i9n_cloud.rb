# encoding: UTF-8

require 'helper/require_integration'
require 'siba-destination-aws-s3/init'

describe Siba::Destination::AwsS3::Cloud do
  before do
    @cls = Siba::Destination::AwsS3::Cloud

    bucket_env = "AWS_S3_SIBA_TEST_BUCKET_NAME"
    access_key_id_env = "AWS_S3_SIBA_TEST_ACCESS_KEY_ID"
    secret_key_env = "AWS_S3_SIBA_TEST_SECRET_ACCESS_KEY"

    @bucket = ENV[bucket_env]
    @access_key_id = ENV[access_key_id_env]
    @secret_key = ENV[secret_key_env]

    flunk "#{bucket_env} environment variable is not set" unless @bucket
    flunk "#{access_key_id_env} environment variable is not set" unless @access_key_id
    flunk "#{secret_key_env} environment variable is not set" unless @secret_key
  end

  it "should upload file to cloud" do
    @cloud = @cls.new @bucket, @access_key_id, @secret_key

    path_to_test_file = prepare_test_file "awss3-u"
    @cloud.upload path_to_test_file
    
    file_name = File.basename path_to_test_file
    @cloud.exists?(file_name).must_equal true
    @cloud.get_file(file_name).must_equal Siba::FileHelper.read(path_to_test_file)
    @cloud.delete(file_name)
  end

  it "should find objects" do
    skip
    @cloud = @cls.new @bucket, @access_key_id, @secret_key
    @cloud.find_objects("my").must_be_instance_of Array
  end
end
