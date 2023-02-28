# frozen_string_literal: true

ActiveAdmin.register Product, namespace: "shops" do
  scope_to :current_admin_user, unless: -> { current_admin_user.admin? }

  menu if: proc { !(current_admin_user.admin? || current_admin_user.super_admin?) }, priority: 1

  permit_params :locale, :name, :description, :origin, :price, :discount, :quantity, :shop_id, :category_id, :trending, images: []

  includes([:category])

  config.per_page = 10

  # Filters
  filter :name
  filter :origin
  filter :price
  filter :discount
  filter :quantity
  filter :category
  filter :trending

  scope "Trending" do |products|
    products.where(trending: true).where(admin_user_id: current_admin_user.id)
  end

  # index page
  index do
    column :id
    column :category
    column :name
    column :origin
    column :trending
    column :price do |product|
      div class: "product-price" do
        number_to_currency(product.price, unit: "", delimiter: ",", separator: ",")
      end
    end
    column "Price Readable" do |product|
      div class: "product-price" do
        number_to_human(product.price)
      end
    end
    column :discount
    column :last_price do |product|
      div class: "product-price" do
        lprice = product.price - product.discount.to_d
        number_to_currency(lprice, unit: "", delimiter: ",", separator: ",")
      end
    end

    column :quantity do |product|
      number_with_delimiter(product.quantity, delimiter: ",")
    end
    column :comments do |product|
      div do
        link_to "View", shops_product_comments_path(product_id: product.id)
      end
    end
    actions
  end

  # Form
  form do |f|
    inputs "Product" do
      input :category
      input :name
      input :origin
      input :price
      input :discount
      input :quantity
      input :description
      input :trending
      input :images, as: :file, input_html: { multiple: true }
    end
    para "Press cancel to return to the list without saving."
    actions
  end

  ## show page
  show do
    attributes_table do
      row :name
      row :category
      row :price
      row :origin
      row :quantity
      row :description
      row :discount
      row :trending
      row :images do |product|
        div class: "slideshow-container" do
          if product.images.attached?
            product.images_attachments.each do |img|
              div class: "product-image mySlides fade" do
                image_tag img.url
              end
            end
          end
          a "❯", class: "right", id: "show_more"
          a "❮", class: "left", id: "back_one"
        end
      end
    end
  end

  # Controller
  controller do
    rescue_from ActiveRecord::RecordNotFound, with: -> { return_to_list }

    def show
      @product = Product.includes(:category, images_attachments: :blob).where(id: params[:id]).references(:category, images_attachments: :blob)&.first

      return_to_list and return if @product.admin_user_id != current_admin_user.id
    end

    # EDIT
    def edit
      redirect_to shops_products_path and return if resource.admin_user_id != current_admin_user.id
    end

    def update
      redirect_to shops_products_path and return if resource.admin_user_id != current_admin_user.id
    end

    # create
    def create
      @product = current_admin_user.products.new(permitted_params[:product])
      if @product.save
        redirect_to shops_product_url(@product)
      else
        resource = @product
        render :new
      end
    end

    # delete
    def delete
      redirect_to shops_products_path and return if resource.admin_user_id != current_admin_user.id
    end

    private

    def return_to_list
      redirect_to shops_products_path
    end

    def scoped_collection
      end_of_association_chain.where(admin_user_id: current_admin_user.id)
    end
  end
end
