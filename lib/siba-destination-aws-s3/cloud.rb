# encoding: UTF-8

require 'aws/s3'

module Siba::Destination
  module AwsS3
    class Cloud
      include Siba::FilePlug
      include Siba::LoggerPlug

      attr_accessor :bucket, :sub_dir, :access_key_id, :secret_key

      def initialize(bucket, access_key_id, secret_key)
        splitted_name = bucket.split("/")
        @bucket = splitted_name.shift
        @sub_dir = splitted_name.join("/")
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
            AWS::S3::S3Object.store path(file_name), file
          end
        end
      end

      def get_backups_list(backup_prefix)
        backups = find_objects backup_prefix    
        siba_file.run_this do
          backups.map do |obj|
            [File.basename(obj.key), obj.last_modified]
          end
        end
      end

      def restore_backup_to_dir(backup_name, dir)
        access_and_close do
          path_to_file = File.join dir, backup_name
          open(path_to_file, 'w') do |file|
            file.write(get_file backup_name)
          end
        end
      end

      def exists?(file_name)
        access_and_close do
          AWS::S3::S3Object.exists? path(file_name)
        end
      end

      def bucket_exists?
        access_and_close do
          AWS::S3::Service.buckets.any?{|a| a.name == bucket}
        end
      end

      def find_objects(object_prefix)
        access_and_close do
          AWS::S3::Bucket.objects(prefix: path(object_prefix))
        end
      end

      def get_file(file_name)
        access_and_close do
          begin
            AWS::S3::S3Object.value path(file_name)
          rescue
            logger.error "Failed to get file #{file_name} from Amazon S3"
            raise
          end
        end
      end

      def delete(file_name)
        access_and_close do
          begin
            AWS::S3::S3Object.delete path(file_name)
          rescue
            logger.error "Failed to delete file #{file_name} from Amazon S3"
            raise
          end
        end
      end

      def check_connection
        siba_file.run_this do
          raise Siba::Error, "Bucket '#{bucket}' does not exist." unless bucket_exists?
          exists? "some_file"
          logger.debug "Access to Amazon S3 is verified"
        end
      rescue Exception
        logger.error "Can not connect to Amazon S3, #{bucket}"
        raise
      end

      private

      def path(file)
        return file if sub_dir.empty?
        sub_dir + "/" + file
      end

      def access_and_close
        siba_file.run_this do
          begin
            AWS::S3::Base.establish_connection!(
              :access_key_id => access_key_id,
              :secret_access_key => secret_key,
              :use_ssl => true);

              AWS::S3::Bucket.set_current_bucket_to bucket
              AWS::S3::S3Object.set_current_bucket_to bucket
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
