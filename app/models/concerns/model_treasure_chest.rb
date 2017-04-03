module ActiveRecord
  module ModelTreasureChest
    extend ActiveSupport::Concern
    module ClassMethods
      #从controller中统一获取参数
      def get_arguments_options options, arguments_list, args={}
        BusinessException.raise '参数类型不正确' unless ([Array, String].include? arguments_list.class)
        arguments = {}
        case arguments_list
          when Array
            arguments_list.each do |argument|
              value_of_argument = if options[argument.to_sym].nil?
                                    if options[argument.to_s].nil?
                                      args[argument.to_sym]
                                    else
                                      options[argument.to_s]
                                    end
                                  else
                                    options[argument.to_sym]
                                  end
              #value_of_argument = options[argument.to_sym]||options[argument.to_s]||args[argument.to_sym]
              arguments[argument.to_sym] = value_of_argument unless value_of_argument.nil?
            end
          when String
            arguments[arguments_list.to_sym] = options[arguments_list.to_sym]||options[arguments_list.to_s]||args[arguments_list.to_sym]
        end
        args.each_pair do |key, value|
          next unless arguments[key.to_sym].blank?
          arguments[key.to_sym] = value
        end
        arguments
      end

      def get_really_user_id id
        return id if id.class == Fixnum
        return id if id.match /^(\d)*$/
        member_info = MemberInfo.find_by_member_id id
        member_info.id
      end

      def get_really_member_id id
        if id.class == Fixnum
          member_info = MemberInfo.find id
          return member_info.member_id
        end
        if id.match /^(\d)*$/
          member_info = MemberInfo.find id.to_i
          return member_info.member_id
        end
        return id
      end

      def upload_file name
        return '' if name.blank?
        uploaded_io = name
        dir = 'images'
        prefix = 'image'
        new_name = ''
        index = 1
        origin_name_with_path = Rails.root.join('public', 'uploads/' + dir, uploaded_io.original_filename)
        File.open(origin_name_with_path, 'wb') do |file|
          file.write(uploaded_io.read)
          new_name = prefix + Time.now.to_s(:number) + EricTools.generate_random_string(3,3) + File.extname(file)
          new_name_with_path = Rails.root.join('public', 'uploads/' + dir, new_name)
          File.rename(origin_name_with_path, new_name_with_path)
          index += 1
        end
        new_name
      end

    end
  end

  class Base
    include ModelTreasureChest
  end
end

