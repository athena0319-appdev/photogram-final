# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  comments_count       :integer
#  email                :string
#  followrequests_count :integer
#  likes_count          :integer
#  password_digest      :string
#  photos_count         :integer
#  private              :boolean
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class User < ApplicationRecord

  has_many(:photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })
  has_many(:followrequests, { :class_name => "Followrequest", :foreign_key => "recipient_id", :dependent => :destroy })
  has_many(:followrequests, { :class_name => "Followrequest", :foreign_key => "recipient_id", :dependent => :destroy })
  has_many(:likes, { :class_name => "Like", :foreign_key => "fan_id", :dependent => :destroy })
end
