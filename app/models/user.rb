class User < ActiveRecord::Base

  has_many :attendance_lists
  has_many :meetups, through: :attendance_lists
  has_many :comments

  validates :provider, presence: true, uniqueness: { scope: :uid }
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :avatar_url, presence: true


  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      username: auth.info.nickname,
      avatar_url: auth.info.image
    )
  end
end
