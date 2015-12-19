class Cms::UserSystem::UserInfosController < Cms::BaseController
  before_filter :need_login
  def export_users_xls
    if request.post?
      begin
        file_name = ::UserSystem::UserInfo.export_excel ::UserSystem::UserInfo.all
        if File.exists? file_name
          io = File.open(file_name)
          io.binmode
          send_data io.read, filename: file_name, disposition: 'inline'
          io.close
          File.delete file_name
        else
          flash[:alert] = '文件不存在！'
          render :export_users_xls
        end
      rescue Exception=> e
        flash[:alert] = dispose_exception e
        render :export_users_xls
      end
    else

    end
  end

end