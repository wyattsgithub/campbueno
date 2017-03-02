class User < ApplicationRecord
  attr_accessor :identity_id

  devise :database_authenticatable, :registerable, :rememberable, :omniauthable

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_save do
    if identity_id.present?
      Identity.where(id: identity_id).update_all(user_id: id)
    end
  end

  after_create do
    if ENV['MAILCHIMP_KEY'].present?
      gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_KEY'])
      gibbon.lists(ENV['MAILCHIMP_LIST_ID']).members.create(body: {
        email_address: email,
        status: "subscribed",
        merge_fields: {FNAME: first_name, LNAME: last_name}
      })
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end
