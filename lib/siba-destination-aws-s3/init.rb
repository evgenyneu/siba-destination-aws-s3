# encoding: UTF-8

require 'siba-destination-aws-s3/cloud'

module Siba::Destination
  module AwsS3                 
    class Init                 
      attr_accessor :cloud

      def initialize(options)  
        bucket = Siba::SibaCheck.options_string options, "bucket"
        access_key_id = Siba::SibaCheck.options_string options, "access_key_id"
        secret_key = Siba::SibaCheck.options_string options, "secret_key"

        @cloud = Siba::Destination::AwsS3::Cloud.new bucket, access_key_id, secret_key
      end                      

      def backup(path_to_backup_file) 
        @cloud.upload path_to_backup_file
      end

      # Returns an array of two-element arrays:
      # [backup_file_name, modification_time]
      def get_backups_list(backup_name)
        @cloud.get_backups_list backup_name
      end

      # Put backup file into dir
      def restore(backup_name, dir)
        @cloud.restore_backup_to_dir backup_name, dir
      end
    end
  end
end
