class Client < ActiveRecord::Base
  has_many :projects
  

  has_secure_password
  validates :name, presence: true

  def slug
    self.name.downcase.gsub(' ','-')
  end

  def self.find_by_slug(name)
    Client.all.find{|client| client.slug == name}
  end
end
