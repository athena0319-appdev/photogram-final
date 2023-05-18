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
  has_secure_password
  validates(:username, {:presence => true, :uniqueness => { :case_sensitive => false }})
  validates(:email, {:presence => true, :uniqueness => { :case_sensitive => false }})
  has_many(:photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })
  has_many(:followrequests, { :class_name => "Followrequest", :foreign_key => "recipient_id", :dependent => :destroy })
  has_many(:likes, { :class_name => "Like", :foreign_key => "fan_id", :dependent => :destroy })

  
  def comments
    return Comment.where({ :author_id => self.id })
  end

  def own_photos
    return Photo.where({ :owner_id => self.id })
  end

  def likes
    return Like.where({ :fan_id => self.id })
  end

  def liked_photos
    array_of_photo_ids = self.likes.map_relation_to_array(:photo_id)

    return Photo.where({ :id => array_of_photo_ids })
  end

  def commented_photos
    array_of_photo_ids = self.comments.map_relation_to_array(:photo_id)

    return Photo.where({ :id => array_of_photo_ids }).distinct
  end

  def sent_follow_requests
    return FollowRequest.where({ :sender_id => self.id })
  end

  def received_follow_requests
    return FollowRequest.where({ :recipient_id => self.id })
  end

  def accepted_sent_follow_requests
    return self.sent_follow_requests.where({ :status => "accepted" })
  end

  def accepted_received_follow_requests
    return self.received_follow_requests.where({ :status => "accepted" })
  end

  def followers
    array_of_follower_ids = self.accepted_received_follow_requests.map_relation_to_array(:sender_id)

    return User.where({ :id => array_of_follower_ids })
  end

  def following
    array_of_leader_ids = self.accepted_sent_follow_requests.map_relation_to_array(:recipient_id)

    return User.where({ :id => array_of_leader_ids })
  end

  def feed
    array_of_leader_ids = self.accepted_sent_follow_requests.map_relation_to_array(:recipient_id)

    return Photo.where({ :owner_id => array_of_leader_ids })
  end

  def discover
    array_of_leader_ids = self.accepted_sent_follow_requests.map_relation_to_array(:recipient_id)

    all_leader_likes = Like.where({ :fan_id => array_of_leader_ids })

    array_of_discover_photo_ids = all_leader_likes.map_relation_to_array(:photo_id)

    return Photo.where({ :id => array_of_discover_photo_ids })
  end
end
