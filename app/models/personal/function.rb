class Personal::Function < ActiveRecord::Base
  belongs_to :parent, foreign_key: :parent_id, class_name: ::Personal::Function
  has_and_belongs_to_many :roles
  has_many :children, foreign_key: :parent_id, class_name: ::Personal::Function

  validates_presence_of :parent_id
  validates_presence_of :parent, :unless => Proc.new { |function| function.parent_id == -1 }

  delegate :title, to: :parent, prefix: true, allow_nil:true

  def update_function attributes
    ::Personal::Function.transaction do
      self.update_attributes! attributes
    end
  end

  class << self

    #获取最上层节点的functions
    def top_functions
      Personal::Function.where parent_id: -1
    end

    #获取所有可以
    def parent_functions
      ::Personal::Function.where("page_url is null or page_url = ''")
    end

    def create_function options
      ::Personal::Function.transaction do
        options = get_arguments_options(options,
                                        [:model_name, :method_name, :title, :description, :parent_id, :page_url],
                                        parent_id: -1)
        function = ::Personal::Function.new options
        function.save!
        function
      end
    end


  end

  def ancestor_ids
    ids = []
    ids << self.id
    if self.parent_id != -1
      ids << self.parent.ancestor_ids
    end
    ids.flatten
  end

end
