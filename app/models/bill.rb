class Bill < ActiveRecord::Base
  validates_presence_of :title, :sponsor_id
end
