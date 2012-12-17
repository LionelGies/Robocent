CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAJIGI6EBO4XKHWQ4A',       # required
    :aws_secret_access_key  => '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'       # required
  }

  if(Rails.env == 'development')
    config.fog_directory  = 'robocent.dev' # required
  elsif(Rails.env == "production")
    config.fog_directory  = 'robocent.production' # required
  end
  
  config.fog_attributes = {'x-amz-server-side-encryption' => 'AES256', 'Cache-Control' => 'max-age=315576000'}
  config.fog_public = false
  config.delete_tmp_file_after_storage = true
end