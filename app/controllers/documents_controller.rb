# encoding: UTF-8

class DocumentsController < ApplicationController

  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_filter :set_users


  # GET /documents
  # GET /documents.json
  def index
    # 文書組0  處室管理員1  組長2
    # 組長的處理方式：列出自己尚未簽收的公文
    if current_user.nil?
       @documents = Document.where("id=0").page(params[:page]).per(5)
    elsif current_user.role == 2
       @documents = Document.where("office=?",current_user.office).order("id DESC").page(params[:page]).per(50)
    elsif current_user.role == 3
       # 處室承辦人
       @documents = Document.where("ifnull(user_get,0)=0 and user_id=?",current_user.id).order("id DESC").page(params[:page]).per(50)
    else
       @documents = Document.order("id DESC").page(params[:page]).per(50)
    end
  end

  def listall
    @documents = Document.order("id DESC").page(params[:page]).per(50)
    @head = "所有"
    render :index
  end

  def liststar
    @documents = Document.where("star IS NOT NULL").order("id DESC").page(params[:page]).per(50)
    @head = "加上星星的"
    render :index
  end

  def listunget
     # 如果還沒有簽到，該datetime欄位為null，此時可以用 ifnull 搜尋
     @documents = Document.where("ifnull(user_get,0)=0").order("id DESC").page(params[:page]).per(50)
     @head = "尚未簽收的"
     render :index
  end

  def listunback
     @documents = Document.where("ifnull(user_back,0)=0").order("id DESC").page(params[:page]).per(50)
     @head = "尚未歸檔的"
     render :index
  end

  def speed
  end

  def speedback

     # 這一段還要再改，1重複文號沒有判斷  2不應選取多筆項目

     @recv=params[:recv]
     @documents = Document.where("received_no=?", @recv).order("id DESC").page(params[:page]).per(50)

     if @documents 
        @documents[0].update_attribute(:user_back, DateTime.now)
        @documents[0].update_attribute(:userid_back, session[:user_id])
        flash[:success]="已歸檔公文如下所列"
     else
        # 尚待處理，此處是臭蟲
        flash[:error]="查無此項公文"
        render :speed
     end
     
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
     if /^give2/ =~ op
        str = op.split("_")
        user = str[1]
        op="give2"
     end

     # 如果使用者沒有選公文，會噴出錯誤，所以加上這一行。
     document_ids ||=[]

     document_ids.each do |doc_id|
        @document = Document.find(doc_id)
        case op
        when "noselect" then
           flash[:error]="您沒有選取任何指令"
        when "yellowstar" then
           @document.update_attribute(:star, 1)
        when "redstar" then
           @document.update_attribute(:star, 2)
        when "unstar" then
           @document.update_attribute(:star, nil)
        when "give2" then
           @document.update_attribute(:user_id, user)
        when "sign" then
           @document.update_attribute(:user_get, DateTime.now)
           @document.update_attribute(:userid_get, session[:user_id])
        when "back" then
           @document.update_attribute(:user_back, DateTime.now)
           @document.update_attribute(:userid_back, session[:user_id])
        when "unsign" then
           @document.update_attribute(:user_get, nil)
           @document.update_attribute(:userid_get, nil)
        when "unback" then
           @document.update_attribute(:user_back, nil)
           @document.update_attribute(:userid_back, nil)
        when "delete" then
           @document.destroy
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
     unless current_user.role <= 2
        flash[:error]="您沒有上傳Excel的權限！"
        redirect_to deny_users_url
     end
  end

   def import
      Document.import(params[:file])
      redirect_to root_url, notice:"資料成功匯入! " 
   end

   def searchform
   end

   def search 
      @keyword="%#{params[:keyword]}%"
      @documents = Document.where("title like ?",@keyword).order("id DESC").page(params[:page]).per(50)
   end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    def set_users
       @users = User.where("office=?", current_user.office)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:received_at, :received_no, :sent_from, :doc_type, :sent_no, :title, :office, :user_id, :user_get, :user_back)
    end
end


