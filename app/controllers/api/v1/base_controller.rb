# class Api::V1::BaseController < ActionController::Base
class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json
  around_filter :around

  def around
    unless params[:session].blank?
      params[:phone] = params[:session][0..-5]
      params[:card_number] = params[:session][-4..-1]
    end
    set_response_code 0
    set_response_message ''
    if params[:device_id].blank?
      params[:device_id] = params[:deviceId] unless params[:deviceId].blank?
    end

    begin
      yield

    rescue Exception => e
      dispose_exception e
      render "/api/v1/error"
    end
  end

  def get_ip
    ip = request.env["HTTP_X_FORWARDED_FOR"]||"127.0.0.1"
    ip = begin ip.split(',')[0] rescue "127.0.0.1" end
  end

  #处理控制器中的异常信息。
  def dispose_exception e, error_messages={:unknow_error => nil}
    case e
      when BusinessException
        set_response_code 1
        set_response_message e.to_s
      when ActiveRecord::RecordInvalid #对于模型中的字段校验，则返回一个hash，分别是字段所对应的错误信息。
        errors = {}
        e.record.errors.each do |k, v|
          k = k.to_s
          errors[k] = v
        end
        set_response_message errors.values[0]
        set_response_code 1
      when ActiveRecord::RecordNotFound
        set_response_message '记录未被找到'
        set_response_code 1
        e.to_s.to_logger
        $@.to_logger
      else
        set_response_message error_messages[:unknow_error]||'发生未知错误'
        set_response_code 1
        e.to_s.to_logger
        $@.to_logger
        ExceptionNotifier.notify_exception(e)
        raise e
    end
  end


  def respond_json_or_jsonp data
    respond_to do |format|
      format.json {
        render :json => data.to_json
      }
      format.js {
        render :json => data, :callback => params[:cb]
      }
    end
  end

  private
  def set_response_code _code=0
    @code = _code
  end

  def set_response_message _message=''
    @message = _message
  end

end
