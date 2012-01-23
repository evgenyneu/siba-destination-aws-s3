# encoding: UTF-8

require 'aws/s3'

module Siba::Destination
  module AwsS3
    class Cloud
      include Siba::FilePlug
      include Siba::LoggerPlug

      attr_accessor :bucket, :access_key_id, :secret_key

      def initialize(bucket, access_key_id, secret_key)
        @bucket = bucket
        @access_key_id = access_key_id
        @secret_key = secret_key

        check_connection
      end

      def upload(src_file)        
        file_name = File.basename src_file
        logger.info "Uploading backup to Amazon S3: #{file_name}"
        access_and_close do
          unless siba_file.file_file? src_file
            raise Siba::Error, "Can not find backup file for uploading: #{src_file}"
          end

          File.open(src_file, "r") do |file|
            AWS::S3::S3Object.store file_name, file, bucket
          end
        end
      end

      def exists(file_name)
        access_and_close do
          AWS::S3::S3Object.exists? file_name, bucket
        end
      end

      def get_file(file_name)
        access_and_close do
          begin
            AWS::S3::S3Object.value file_name, bucket
          rescue
            logger.error "Failed to get file #{file_name} from Amazon S3"
            raise
          end
        end
      end

      def delete(file_name)
        access_and_close do
          begin
            AWS::S3::S3Object.delete file_name, bucket
          rescue
            logger.error "Failed to delete file #{file_name} from Amazon S3"
            raise
          end
        end
      end

      def check_connection
        access_and_close {}
        logger.debug "Access to Amazon S3 is verified"
      rescue Exception
        logger.error "Can not establish connection with Amazon S3, #{bucket}"
        raise
      end

      private

      def access_and_close
        siba_file.run_this do
          begin
            logger.debug "Establishing connection with Amazon S3 service"

            AWS::S3::Base.establish_connection!(
              :access_key_id => access_key_id,
              :secret_access_key => secret_key);

              AWS::S3::Bucket.find bucket
              yield
          ensure
            begin
              AWS::S3::Base.disconnect!
            rescue
            end
          end
        end
      end
    end
  end
end
