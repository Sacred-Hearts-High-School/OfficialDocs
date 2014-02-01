require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  setup do
    @document = documents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document" do
    assert_difference('Document.count') do
      post :create, document: { doc_type: @document.doc_type, manager_back: @document.manager_back, manager_get: @document.manager_get, manager_id: @document.manager_id, office_id: @document.office_id, received_at: @document.received_at, received_no: @document.received_no, sent_from: @document.sent_from, sent_no: @document.sent_no, title: @document.title }
    end

    assert_redirected_to document_path(assigns(:document))
  end

  test "should show document" do
    get :show, id: @document
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @document
    assert_response :success
  end

  test "should update document" do
    patch :update, id: @document, document: { doc_type: @document.doc_type, manager_back: @document.manager_back, manager_get: @document.manager_get, manager_id: @document.manager_id, office_id: @document.office_id, received_at: @document.received_at, received_no: @document.received_no, sent_from: @document.sent_from, sent_no: @document.sent_no, title: @document.title }
    assert_redirected_to document_path(assigns(:document))
  end

  test "should destroy document" do
    assert_difference('Document.count', -1) do
      delete :destroy, id: @document
    end

    assert_redirected_to documents_path
  end
end
