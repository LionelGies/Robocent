require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, contact: { address_1: @contact.address_1, address_2: @contact.address_2, city: @contact.city, company_name: @contact.company_name, custom_1: @contact.custom_1, custom_2: @contact.custom_2, custom_3: @contact.custom_3, custom_4: @contact.custom_4, custom_5: @contact.custom_5, do_not_import: @contact.do_not_import, email: @contact.email, first_name: @contact.first_name, last_name: @contact.last_name, list_id: @contact.list_id, phone_number: @contact.phone_number, state: @contact.state, unique_identifier: @contact.unique_identifier, user_id: @contact.user_id, zip: @contact.zip }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: { address_1: @contact.address_1, address_2: @contact.address_2, city: @contact.city, company_name: @contact.company_name, custom_1: @contact.custom_1, custom_2: @contact.custom_2, custom_3: @contact.custom_3, custom_4: @contact.custom_4, custom_5: @contact.custom_5, do_not_import: @contact.do_not_import, email: @contact.email, first_name: @contact.first_name, last_name: @contact.last_name, list_id: @contact.list_id, phone_number: @contact.phone_number, state: @contact.state, unique_identifier: @contact.unique_identifier, user_id: @contact.user_id, zip: @contact.zip }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end
end
