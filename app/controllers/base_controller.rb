class BaseController < ApplicationController

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def encode_token(payload)
    payload[:exp] = 4.hours.from_now.to_i
    JWT.encode(payload, SECRET_KEY)
  end 

  def decode_token
    header = request.headers['Authorization']
    if header
      token = header.split(" ")[1]
      begin 
        decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
        payload = decoded[0]
        
        decoded
      rescue JWT::ExpiredSignature => exception
        exception
      rescue JWT::DecodeError
        nil
      end  
    end    
  end

  def auth_admin
    result = decode_token
    return render json: { message: "Sessão expirada, faça login para continuar." }, status: :unauthorized if result.is_a?(JWT::ExpiredSignature)
    return render_unauthorized unless result

    admin_id = result[0]['admin_id']
    @admin = Admin.find_by(id: admin_id)

    return render_unauthorized unless @admin
  end

  private

  def render_unauthorized
    render json: { message: "Faça seu login antes de continuar."}, status: :unauthorized
  end  
end