class Person < ActiveRecord::Base
  mount_uploader :picture, PictureUploader


end
