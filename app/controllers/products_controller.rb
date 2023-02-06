# frozen_string_literal: true

class ProductsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  # append_before_action :recommend, :trending, only: %i[index]
  before_action :set_exclude_ids, only: %i[index show search]
  append_before_action :list_of_products, only: %i[index]

  # GET /products or /products.json
  def index
    render json: {
             products: ActiveModelSerializers::SerializableResource.new(@products, each_serializer: ProductSerializer),
             trending: [],
           }
  end

  # GET /products/1 or /products/1.json
  def show
    @product = Product.includes(:votes_for, images_attachments: :blob).where(id: params[:id]).references(:images_attachments).first
    @related = Product.includes(:votes_for, images_attachments: :blob).where(category_id: @product.category_id)
      .references(:images_attachments)
      .where.not(id: @exclude_ids)
      .order(updated_at: :desc).limit(6)

    lst = @related.last

    if lst
      render_show_with_comment if stale? [@product, lst]
    else
      render_show_with_comment if stale? [@product]
    end
  end

  # GET /categories
  def categories
    @categories = Category.order(name: :asc)

    if stale?(@categories)
      expires_in 10.days

      render json: @categories
    end
  end

  # GET /product/search
  def search
    query = params[:q]
    if query.nil? or query.empty?
      render json: { okay: false, message: "Query is required" }, status: :bad_request and return # to prevent double render
    end

    query.downcase!
    @products = Product.includes(images_attachments: :blob).joins(:category)
    .where.not(id: @exclude_ids)
    .where("lower(products.name) LIKE ? OR lower(categories.name) LIKE ? ", "%#{query}%", query).limit(10)

    render json: @products
  end

  private

  def set_exclude_ids
    if customer_signed_in?
      cart_products = CartItem.joins(:product).where(cart_id: current_customer.cart_ids).pluck(:product_id)
      order_products = OrderItem.joins(:order).where(order: { customer_id: current_customer.id }).pluck(:product_id)
      @exclude_ids = cart_products + order_products
    else
      @exclude_ids = []
    end
  end

  def render_show_with_comment
    expires_in 1.days, public: true

    render json: {
      product: ProductDetailSerializer.new(@product),
      related_products: ActiveModelSerializers::SerializableResource.new(@related, each_serializer: ProductSerializer),
      comments: ActiveModelSerializers::SerializableResource.new(@product.comments.limit(4), each_serializer: CommentSerializer),
    }
  end

  def render_show
    render json: {
      product: ActiveModelSerializers::SerializableResource.new(@product, each_serializer: ProductSerializer),
      related_products: ActiveModelSerializers::SerializableResource.new(@related, each_serializer: ProductSerializer),
    }
  end

  # GET /recommend
  def recommend
    if customer_signed_in?
      # based on search history
      for_signed_in_customer
    else
      for_guest
    end
  end

  # 5 products are enough
  def trending
    @trending = []
  end

  # list of products
  def list_of_products
    cat = params[:category]&.titlecase

    if cat == "All"
      @products = Product.get_list_but_exclude(@exclude_ids).to_a
    else
      category = Category.find_by(name: cat)
      @products = Product.with_category(category, @exclude_ids).to_a
    end

    @products.delete_at(-1) if @products.size.odd?
  end

  # for authorized
  def for_signed_in_customer
    @recommended = Product.all.limit(6)
  end

  # for un authorized request
  def for_guest
    @recommended = Product.where.not(id: @products.ids).limit(6)
  end
end
