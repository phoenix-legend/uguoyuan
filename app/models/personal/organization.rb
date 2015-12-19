class Personal::Organization < ActiveRecord::Base
  has_and_belongs_to_many :roles, :class_name => '::Personal::Role'
  has_and_belongs_to_many :employees, :class_name => '::Personal::Employee'

  belongs_to :parent,  :class_name => "::Personal::Organization", :foreign_key => "parent_id"
  has_many :children, :class_name => "::Personal::Organization", :foreign_key => "parent_id"

  validates :code, uniqueness: true
  scope :permitted, ->(employee) { employee.organizations.map(&:descendant_without_self).reduce(&:+)}


  def ancestors
    the_ancestors = []
    unless self.parent.nil?
      the_ancestors << self.parent.ancestors.flatten
    end
    the_ancestors << self
    the_ancestors.flatten
  end

  def descendant
    the_descendants  = []
    the_descendants << self
    unless self.children.size == 0
      the_descendants << self.children.map(&:descendant)
    end
    the_descendants.flatten
  end

  def descendant_without_self
    the_descendant = descendant
    the_descendant.delete(self)
    the_descendant
  end

end
