class TransactionsController < ApplicationController
  skip_before_action :authenticate_user!,
    only: [:new, :create]

  def new
    @product = Product.find_by!(
      permalink: params[:permalink]
    )
  end

  def pickup
    @sale = Sale.find_by!(guid: params[:guid])
    @product = @sale.product
  end

  def create
    product = Product.find_by!(
      permalink: params[:permalink]
    )

    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        amount:      product.price,
        currency:    "usd",
        source:      token,
        description: params[:stripeEmail]
      )
      @sale = product.sales.create!(
        email:      params[:stripeEmail],
        stripe_id:  charge.id
      )
      redirect_to pickup_url(guid: @sale.guid)
    rescue Stripe::CardError => e
      # The card has been declined or
      # some other error has occurred
      @error = e
      render :new
    end
  end

  def download
    @sale = Sale.find_by!(guid: params[:guid])

    resp = HTTParty.get(@sale.product.file.url)

    filename = @sale.product.file.url
    send_data resp.body,
      :filename => File.basename(filename),
      :content_type => resp.headers['Content-Type']
  end

end