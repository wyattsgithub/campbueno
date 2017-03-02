class Identity < ApplicationRecord
  belongs_to :user
  validates :uid, presence: true, uniqueness: {sscope: :provider}
  validates :provider, presence: true
end
