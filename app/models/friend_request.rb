class FriendRequest < ApplicationRecord
  # Direct associations

  belongs_to :sender,
             :class_name => "User",
             :counter_cache => :sent_friend_requests_count

  # Indirect associations

  # Validations

  validates :recipient_id, :uniqueness => { :scope => [:sender_id], :message => "already requested" }

  validates :recipient_id, :presence => true

  validates :sender_id, :presence => true

end
