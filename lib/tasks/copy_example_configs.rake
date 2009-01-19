desc "Copy application sample config for dev/test purposes"
task :copy_example_configs do
  if Rails.env == 'development' or Rails.env == 'test'
    Dir['**/*.example.*'].each do |example_file|
      settings_file = "#{File.dirname(example_file)}/#{File.basename(example_file).sub(/\.example\./,'.')}"
      unless File.exist?(settings_file)
        puts "copying #{example_file} to #{settings_file}"
        FileUtils.cp(example_file, settings_file)
      end
    end
  end
end
