# A sample Guardfile           
# More info at https://github.com/guard/guard#readme

guard 'minitest', :notify=>false do
  watch(%r|^test/unit/(.*\/)*test_(.*)\.rb|)
  watch(%r|^lib/siba-destination-aws-s3/(.*\/)*([^/]+)\.rb|) do |m| 
    "test/unit/#{m[1]}test_#{m[2]}.rb" unless m[2][0] == '.' 
  end
end
