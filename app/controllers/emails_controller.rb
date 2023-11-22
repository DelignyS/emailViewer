class EmailsController < ApplicationController
  before_action :set_email, only: %i[ show edit update destroy ]

  # GET /emails or /emails.json
  def index
    @emails = Email.all
    @email = Email.new
  end

  # GET /emails/1 or /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails or /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace('email', partial: 'emails/email', locals: { email: @email }) }
        format.html { redirect_to emails_path }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_email', partial: 'form', locals: { email: @email }) }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /emails/1 or /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to email_url(@email), notice: "Email was successfully updated." }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @email.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@email)) }
      format.html { redirect_to emails_url, notice: "Email was successfully destroyed." }
    end
  end
  private
   
    def set_email
      @email = Email.find(params[:id])
    end

    def email_params
      params.require(:email).permit(:object, :body)
    end
end
