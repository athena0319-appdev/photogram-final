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
end
