module V1
  module Admin
    class UsersController < BaseController
      before_action :auth_admin, except: [:signup, :signin]
      before_action :check_login_params, only: [:signin]

      def signup
        @admin = ::Admin.new signup_params

        if @admin.save
          token = encode_token({admin_id: @admin.id})
          render json: map_admin(token), status: :created
        else
          render json: { message: @admin.errors.full_messages }, status: :unprocessable_entity
        end 
      end  

      def signin
        @admin = ::Admin.find_by(email: params[:email])
        if @admin && @admin.authenticate(params[:password])
          token = encode_token({admin_id: @admin.id})
          render json: map_admin(token), status: :accepted
        else   
          render json: { message: "Usuario ou senha inválidos."}, status: :unauthorized
        end  
      end
      
      def get_account
        render json: {
          id: @admin.id,
          name: @admin.name,
          email: @admin.email,
          created_at: @admin.created_at
        }, status: :ok
      end  

      private 

      def signup_params
        params.permit(:name, :email, :password)
      end 

      def check_login_params
        unless params[:email].present? && params[:password].present?
          return render json: { message: "Email e senha são obrigatórios."}, status: :bad_request
        end  
      end  

      def map_admin(token)
        {
          id: @admin.id,
          name: @admin.name,
          email: @admin.email,
          created_at: @admin.created_at,
          token: token
        }
      end  
    end  
  end  
end  
