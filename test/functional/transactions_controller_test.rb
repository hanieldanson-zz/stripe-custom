class TransactionsControllerTest < ActionController::TestCase
	test "should post create" do
		product = Product.create(
			permalink: 'test_product',
			price:     100
		)		
	email = 'pete@example.com'
	token = 'tok_test'

	post :create, email: email, stripeToken: token

	assert_not_nil assigns(:sale)
	assert_not_nil assigns(:sale).stripe_id
	assert_equal product.id, assigns(:sale).product_id
	assert_equal email, assigns(:sale).email
	end
end