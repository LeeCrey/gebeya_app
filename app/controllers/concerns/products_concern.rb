# frozen_string_literal: true

module ProductsConcern

  # list of products
  def list_of_products
    @offset = params[:offset].to_i * 8
    if @category == "All"
      @products = Product.get_list_but_exclude(@exclude_ids, @shop_ids, @offset).to_a
    else
      category = Category.find_by(name: @category)
      @products = Product.with_category(category, @exclude_ids, @shop_ids, @offset).to_a
    end

    @products.delete_at(-1) if @products.size.odd?
  end

  # GET /recommend
  def prepare_recommended
    if customer_signed_in?
      histories = current_customer.search_histories
      if histories.count != 0
        history = histories.order('random()').limit(1).first.body
        @exclude_ids += @products.map(&:id)
        @recommend = Product.includes(images_attachments: :blob).joins(:category).where.not(id: @exclude_ids)
          .where("lower(products.name) LIKE ? OR lower(categories.name) LIKE ? ", "%#{history}%", history)
          .order(id: :desc).limit(6)
      else
        @recommend = []
      end
    else
      @recommend = Product.includes(images_attachments: :blob).where.not(id: @products).order('random()').limit(6)
    end
  end

  # 5 products are enough
  def set_trending
    @trending = Product.includes(images_attachments: :blob).where(trending: true).order("random()").limit(6)
  end

  def set_exclude_ids
    if customer_signed_in?
      cart_products = CartItem.joins(:cart).where(cart: { customer_id: current_customer.id }).pluck(:product_id)
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
             related_products: product_serializer_helper(@related),
             comments: comment_serializer(@product.comments.limit(4)),
           }
  end

  def render_show
    hash = { product: product_serializer_helper(@product), related_products: product_serializer_helper(@related) }

    render json: hash
  end

  def product_serializer_helper(products)
    ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer)
  end

  def comment_serializer(comments)
    ActiveModelSerializers::SerializableResource.new(comments, each_serializer: CommentSerializer)
  end
end
