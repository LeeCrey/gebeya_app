# frozen_string_literal: true

class ProductsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_action :set_offset, only: %i[index search]
  before_action :get_neareset_shops, only: %i[index]
  before_action :set_exclude_ids, only: %i[index show search]
  append_before_action :set_category, :set_trending, :list_of_products, :prepare_recommended, only: %i[index]

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
    @product = Product.where(id: params[:id]).first
    @related = Product.includes(images_attachments: :blob)
      .where(category_id: @product.category_id)
      .where.not(id: (@exclude_ids << @product.id)).order("random()").last(6)

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
    query = params[:q]&.strip
    if query.nil? or query.empty?
      render json: { okay: false, message: "Query is required" }, status: :bad_request and return # to prevent double render
    end

    offset = params[:offset]&.to_i * 10

    query.downcase!
    products = Product.joins(:category).includes(:category, images_attachments: :blob)
      .where.not(id: @exclude_ids)
      .where("lower(products.name) LIKE ? OR lower(categories.name) LIKE ? ", "%#{query}%", query)
      .order(id: :desc).offset(offset).limit(10)&.to_a

    current_customer.search_histories.new(body: query).save if customer_signed_in?

    products.pop if products.count.odd?

    render json: { products: product_serializer_helper(products) }
  end

  private

  def set_category
    category = params[:category] ||= "All"
    @category = category&.titlecase
  end

  def get_neareset_shops
    lat = params[:latitude]
    lgt = params[:longitude]

    if (lat.nil? or lat.empty?) or (lgt.nil? or lgt.empty?)
      render json: { okay: false, message: "Latitude and longitude are required" }, status: :bad_request and return
    end

    @shop_ids = AdminUser.nearest(lat, lgt).map(&:id)
  end

  def set_offset
    @offset = params[:offset].to_i
  end

  include ProductsConcern
end
