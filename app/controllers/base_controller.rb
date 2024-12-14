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

        if Time.now.to_i > payload['exp']
          render json: { message: "Sessão expirada, faça login para continuar" }, status: :unauthorized
        end
        
        decoded
      rescue JWT::DecodeError
        nil  
      end  
    end    
  end

  def auth_admin
    token = decode_token
    return render_unauthorized unless token

    admin_id = token[0]['admin_id']
    @admin = Admin.find_by(id: admin_id)

    return render_unauthorized unless @admin
  end

  private

  def render_unauthorized
    render json: { message: "Faça seu login antes de continuar."}, status: :unauthorized
  end  
end