# encoding: UTF-8

require 'siba-destination-aws-s3/cloud'

module Siba::Destination
  module AwsS3                 
    class Init                 
      include Siba::LoggerPlug

      DEFAULT_ACCESS_KEY_ID_ENV_NAME = "SIBA_AMAZON_ACCESS_KEY_ID"
      DEFAULT_SECRET_KEY_ENV_NAME = "SIBA_AMAZON_SECRET_ACCESS_KEY"

      attr_accessor :cloud

      def initialize(options)  
        bucket = Siba::SibaCheck.options_string options, "bucket"

        access_key_id_name = "access_key_id"
        secret_key_name = "secret_access_key"
        access_key_id = Siba::SibaCheck.options_string options, access_key_id_name, true, ENV[DEFAULT_ACCESS_KEY_ID_ENV_NAME]
        secret_key = Siba::SibaCheck.options_string options, secret_key_name, true, ENV[DEFAULT_SECRET_KEY_ENV_NAME]

        raise Siba::CheckError, "Missing '#{access_key_id_name}' option" if access_key_id.nil?
        raise Siba::CheckError, "Missing '#{secret_key_name}' option" if secret_key.nil?

        logger.info "Checking connection to Amazon S3"
        @cloud = Siba::Destination::AwsS3::Cloud.new bucket, access_key_id, secret_key
      end                      

      def backup(path_to_backup_file) 
        @cloud.upload path_to_backup_file
      end

      # Returns an array of two-element arrays:
      # [backup_file_name, modification_time]
      def get_backups_list(backup_name)
        logger.info "Getting the list of backups from Amazon S3"
        @cloud.get_backups_list backup_name
      end

      # Put backup file into dir
      def restore(backup_name, dir)
        logger.info "Downloading backup from Amazon S3"
        @cloud.restore_backup_to_dir backup_name, dir
      end
    end
  end
end
