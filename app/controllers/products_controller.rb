# frozen_string_literal: true

class ProductsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  # append_before_action :recommend, :trending, only: %i[index]
  before_action :set_exclude_ids, only: %i[index show search]
  before_action :set_category, only: %i[index]
  append_before_action :set_trending, only: %[index]
  append_before_action :list_of_products, only: %i[index]
  append_before_action :prepare_recommended, only: %i[index]

  # GET /products or /products.json
  def index
    render json: {
             trending: product_serializer_helper(@trending),
             products: product_serializer_helper(@products),
             recommended: product_serializer_helper(@recommend),
           }
  end

  # GET /products/1 or /products/1.json
  def show
    @product = Product.includes(images_attachments: :blob).where(id: params[:id]).references(:images_attachments).first
    @related = Product.includes(images_attachments: :blob)
      .where(category_id: @product.category_id)
      .where.not(id: (@exclude_ids << @product.id))
      .order(updated_at: :desc)
      .references(:images_attachments)
      .limit(6)

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
      .where("lower(products.name) LIKE ? OR lower(categories.name) LIKE ? ", "%#{query}%", query)
      .order(id: :desc)
      .limit(10)

    current_customer.search_histories.new(body: query).save if customer_signed_in?

    render json: {
      products: product_serializer_helper(@products),
    }
  end

  private

  def set_category
    @category = params[:category]&.titlecase ||= "All"
  end

  include ProductsConcern
end
