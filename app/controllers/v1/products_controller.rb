module V1
  class ProductsController < BaseController
    before_action :auth_admin
    before_action :get_product, except: [:register, :list]

    def register
      product = Product.new

      product.name = params[:name]
      product.quantity = params[:quantity]
      product.admin = @admin
      
      begin
        product.product_price = params[:price]
      rescue
        return render json: { message: ["Verifique se o preço é válido, e tente novamente."] }, status: :unprocessable_entity
      end  
      
      if product.save
        render json: product.map_product, status: :created
      else
        render json: { message: product.errors.full_messages }, status: :unprocessable_entity
      end  
    end
    
    def details
      render json: @product.map_product, status: :ok
    end
    
    def update
      permitted_params = params.permit(:name, :quantity, :price)
      
      @product.name = permitted_params[:name] if permitted_params[:name].present?
      @product.quantity = permitted_params[:quantity] if permitted_params[:quantity].present?
      @product.product_price = permitted_params[:price] if permitted_params[:price].present?

      if @product.save
        render json: @product.map_product, status: :ok
      else
        render json: { message: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def remove 
      if @product.destroy
        render json: { message: ["Produto removido com sucesso."] }, status: :ok
      else
        render json: { message: ["Algo deu errado, tente novamente."] }, status: :unprocessable_entity
      end  
    end 
    
    def list
      products = Product.order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
      
      render json: {
        current_page: products.current_page,
        next_page: products.next_page,
        previous_page: products.previous_page,
        total_pages: products.total_pages,
        total_entries: products.total_entries,
        products: products.map do |product|
          product.map_product_list
        end
      }, status: :ok
    end  

    private 

    def get_product
      @product = Product.find_by(id: params[:id])

      return render json: { message: ["Nenhum produto encontrado."] }, status: :not_found unless @product
    end  
 
  end    
end 