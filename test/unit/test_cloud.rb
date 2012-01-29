# encoding: UTF-8

require 'helper/require_unit'
require 'siba-destination-aws-s3/init'

describe Siba::Destination::AwsS3::Cloud do
  before do                    
    @obj = Siba::Destination::AwsS3::Cloud.new "bucket", "two", "umi"
  end

  it "should assign variables" do
    @obj.bucket.must_equal "bucket"
    @obj.access_key_id.must_equal "two"
    @obj.secret_key.must_equal "umi"
  end

  it "should upload" do
    @obj.upload "/file"
  end
  
  it "should upload" do
    @obj.get_backups_list "backups"
  end
end
