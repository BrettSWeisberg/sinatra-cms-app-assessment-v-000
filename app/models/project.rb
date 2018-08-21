class Project < ActiveRecord::Base
  belongs_to :client


  def slug
    self.name.downcase.gsub(' ','-')
  end
  
  def self.find_by_slug(name)
    Project.all.find{|project| project.slug == name}
  end
end
