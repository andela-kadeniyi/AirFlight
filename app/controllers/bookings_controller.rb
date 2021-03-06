class BookingsController < ApplicationController
  protect_from_forgery :except => [:processed, :payment_notification]
  before_action :authenticate_user, :only => [:new, :create]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @flight = Flight.find(params[:flight_id])
    @booking = Booking.new
    @passenger_number = params[:passenger_no].to_i unless params[:passenger_no].nil?

    @passenger_number.times do
      @booking.passengers.build
    end
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id
    respond_to do |format|
      if @booking.save
    # Binding.pry
        @booking_id_store = @booking.id
        format.html { redirect_to @booking }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def payment_notification
    @booking = Booking.find_by_id(params[:invoice])
    status = params[:payment_status]
    @booking.payment_status = status
    @booking.save
    render nothing: true
  end


  def processed
    redirect_to flights_paymentstatus_url, notice: 'Booking successful'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:flight_id, passengers_attributes: [ :name, :email ])
    end
end
