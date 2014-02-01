json.array!(@documents) do |document|
  json.extract! document, :id, :received_at, :received_no, :sent_from, :doc_type, :sent_no, :title, :office_id, :manager_id, :manager_get, :manager_back
  json.url document_url(document, format: :json)
end
