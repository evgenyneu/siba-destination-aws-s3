# encoding: UTF-8

require 'helper/require_integration'
require 'siba-destination-aws-s3/init'

describe Siba::Destination::AwsS3::Cloud do
  before do
    @cls = Siba::Destination::AwsS3::Cloud
    @init = Siba::Destination::AwsS3::Init

    bucket_env = "SIBA_TEST_AWS_S3_BUCKET_NAME"
    access_key_id_env = @init::DEFAULT_ACCESS_KEY_ID_ENV_NAME
    secret_key_env = @init::DEFAULT_SECRET_KEY_ENV_NAME

    @bucket = ENV[bucket_env]
    @access_key_id = ENV[access_key_id_env]
    @secret_key = ENV[secret_key_env]

    flunk "#{bucket_env} environment variable is not set" unless @bucket
    flunk "#{access_key_id_env} environment variable is not set" unless @access_key_id
    flunk "#{secret_key_env} environment variable is not set" unless @secret_key
  end

  it "should upload file to cloud and get the list" do
    begin
      @cloud = @cls.new @bucket, @access_key_id, @secret_key

      backup_name = "awss3-u"
      path_to_test_file = prepare_test_file backup_name
      @cloud.upload path_to_test_file
      
      file_name = File.basename path_to_test_file
      @cloud.exists?(file_name).must_equal true
      @cloud.get_file(file_name).must_equal Siba::FileHelper.read(path_to_test_file)

      # get list
      list = @cloud.get_backups_list backup_name
      full_backup_name = list[0][0]
      full_backup_name.must_match /^#{backup_name}/
      list[0][1].must_be_instance_of Time

      # restore backup
      dest_dir = mkdir_in_tmp_dir "awsbk"
      @cloud.restore_backup_to_dir full_backup_name, dest_dir
      path_to_dest_file = File.join dest_dir, full_backup_name
      File.file?(path_to_dest_file).must_equal true
      FileUtils.compare_file(path_to_test_file, path_to_dest_file).must_equal true
    ensure
      @cloud.delete(file_name)
      @cloud.exists?(file_name).must_equal false
    end
  end

  it "should find objects" do
    @cloud = @cls.new @bucket, @access_key_id, @secret_key
    @cloud.find_objects("my").must_be_instance_of Array
  end
end
