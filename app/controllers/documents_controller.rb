# encoding: UTF-8

class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    #@documents = Document.all
    @documents = Document.order("id DESC").page(params[:page]).per(5)
  end

  def listall
    @documents = Document.order("id DESC").page(params[:page]).per(50)
  end

  def listunget
     # 如果還沒有簽到，該datetime欄位為null，此時可以用 ifnull 搜尋
     @documents = Document.where("ifnull(manager_get,0)=0").order("id DESC").page(params[:page]).per(50)
  end

  def listunback
     @documents = Document.where("ifnull(manager_back,0)=0").order("id DESC").page(params[:page]).per(50)
  end


  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: '一筆公文成功新增。' }
        format.json { render action: 'show', status: :created, location: @document }
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: '公文資料修改成功。' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # 多選處理
  def multiupdate
     document_ids = params[:document_ids]
     op = params[:op]
     document_ids.each do |doc_id|
        @document = Document.find(doc_id)
        case op
        when "sign" then
           @document.update_attribute(:manager_get, DateTime.now)
        when "back" then
           @document.update_attribute(:manager_back, DateTime.now)
        when "unsign" then
           @document.update_attribute(:manager_get, nil)
        when "unback" then
           @document.update_attribute(:manager_back, nil)
        when "delete" then
           @document.update_attribute(:manager_get, DateTime.now)
        else raise "不支援這個批次處理指令！駭客行為已記錄！"
        end
     end

     redirect_to root_url, notice:"批次處理已完成！"
  end



  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  def upload

  end

   def import
      Document.import(params[:file])
      redirect_to root_url, notice:"資料成功匯入! " 
   end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:received_at, :received_no, :sent_from, :doc_type, :sent_no, :title, :office_id, :manager_id, :manager_get, :manager_back)
    end
end


