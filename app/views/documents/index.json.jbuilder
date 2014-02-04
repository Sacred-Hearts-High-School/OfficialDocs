json.array!(@documents) do |document|
  json.extract! document, :id, :received_at, :received_no, :sent_from, :doc_type, :sent_no, :title, :office_id, :user_id, :user_get, :user_back
  json.url document_url(document, format: :json)
end
