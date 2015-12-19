class Personal::Role < ActiveRecord::Base
  validates_presence_of :name
  has_and_belongs_to_many :functions
  has_and_belongs_to_many :employees


  def reset_functions function_ids
    ::Personal::Role.transaction do
      self.functions.clear
      function_ids.each do |id|
        self.add_function id.to_i
      end
    end
  end

  def add_function function_id
    ::Personal::Role.transaction do
      return true if self.function_ids.include? function_id
      function = Personal::Function.find function_id
      functions = function.ancestor_ids.collect { |id|
        Personal::Function.find id
      }
      functions.each do |function|
        next if self.function_ids.include? function.id
        self.functions << function
      end
    end
  end

  def update_role option
    ::Personal::Role.transaction do
      self.update_attributes! option
    end
  end

  class << self
    def create_role option
      ::Personal::Role.transaction do
        role = ::Personal::Role.new get_arguments_options(option, [:name])
        role.save!
        role
      end
    end

    def add_admin_role_add_all_functions
      ::Personal::Role.transaction do
        role = ::Personal::Role.create_role name: 'admin'
        Personal::Function.all.each do |function|
          role.add_function function.id
        end
      end
    end
  end
end