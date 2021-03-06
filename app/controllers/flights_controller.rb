class FlightsController < ApplicationController

  def index
    @dates = Flight.order("start_time asc").all.map { |flight| [flight.start_time.strftime("%b %d %Y")] }.uniq
    @passengers = [1, 2, 3, 4]
    @airports = Airport.all

    if !params[:from_airport].nil?
      @from = params[:from_airport]
      @to = params[:to_airport]
      @date = params[:date]
      @passengers_select = params[:passengers]
      @flightsearch = Flight.search(@from, @to, @date)
    end
  end


  def paymentstatus
    FlightMailer.flight_details.deliver_later!(wait: 1.minute)
    render 'paymentstatus.html.erb'
  end

  private
  def flight_params
    params.permit(:from_airport, :to_airport, :date, :passengers)
  end
end
