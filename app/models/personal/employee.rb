class Personal::Employee < ActiveRecord::Base
  IN_SEVICE = 1
  DIMISSION = 0
  STATUS = [IN_SEVICE, DIMISSION]


  has_and_belongs_to_many :roles, :class_name => '::Personal::Role'
  has_and_belongs_to_many :organizations, :class_name => '::Personal::Organization'


  validates_confirmation_of :password, :message => '两次输入密码不一致'
  validates_presence_of :password, :message => '密码不能为空'
  validates_uniqueness_of :email, :message => 'email 已经存在'
  validates_presence_of :email, :message => 'email 必须填写'
  validates_uniqueness_of :work_number, :message => '工号不能重复', :allow_blank => true
  validates_presence_of :real_name, :message => '姓名必须填写'
  validates_format_of :email, with: EricTools::RegularConstants::EmailRegular, :message => '邮箱格式不正确'
  validate :password_MD5_can_not_be_blank_MD5
  validates :status, inclusion: {in: STATUS}


  def only_one_organization?
    self.organizations.count == 1
  end


  def in_service?
    self.status == 1
  end


  def functions
    roles = self.organizations.collect { |org| org.roles }
    roles << self.roles
    roles = (roles.flatten).uniq

    functions = roles.collect { |role|
      role.functions
    }
    functions = functions.flatten
    roles_functions = functions.uniq
    roles_functions
  end

  def reset_roles role_ids
    ::Personal::Employee.transaction do
      self.roles.clear
      role_ids.each do |id|
        r = ::Personal::Role.find id.to_i
        next if self.roles.exists? r
        self.roles << r
      end
    end
    self
  end

  def password_MD5_can_not_be_blank_MD5
    errors.add(:password, "新密码不能为空") if self.password == Digest::MD5.hexdigest('')
  end

  def modify_password options
    options = ::Personal::Employee.get_arguments_options options, [:old_password, :new_password, :new_password_confirmation]
    BusinessException.raise '密码不正确' if !(self.password == Digest::MD5.hexdigest(options[:old_password]))
    self.password = Digest::MD5.hexdigest(options[:new_password])
    self.password_confirmation = Digest::MD5.hexdigest(options[:new_password_confirmation])
    self.save!
  end




  class << self

    #注册一个会员
    # ::Personal::Employee.create_employee is_teacher:"on", email: "ericliu1002000@163.com", password:"111111", real_name: "ericliu", password_confirmation: "111111"
    # #
    def create_employee(current_employee, options)
      ::Personal::Employee.transaction do

        options[:password] = '111111'
        options[:password_confirmation] = '111111'
        employee = ::Personal::Employee.new options
        employee.status = ::Personal::Employee::IN_SEVICE
        employee.password = Digest::MD5.hexdigest(employee.password)
        employee.password_confirmation = Digest::MD5.hexdigest(employee.password_confirmation)
        employee.save!



        employee
      end
    end

    def update_employee(employee_id, options)
      ::Personal::Employee.transaction do
        employee = ::Personal::Employee.find(employee_id)
        if options[:organization_ids].nil?
          options[:organization_ids] = []
        end
        employee.update_attributes! options



        employee
      end
    end

    def login email, password
      password = Digest::MD5.hexdigest(password)
      employee = ::Personal::Employee.where(email: email, password: password).first
      BusinessException.raise '用户名和密码不匹配' if employee.blank?
      BusinessException.raise '您已离职' unless employee.status == ::Personal::Employee::IN_SEVICE
      employee
    end

  end

end