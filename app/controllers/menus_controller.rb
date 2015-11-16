require "http"

class MenusController < ActionController::Base
  protect_from_forgery with: :exception

  def menu

    @date = Date.new params[:year].to_i,  params[:month].to_i, params[:day].to_i

    menu_response = retrieve_menu @date

    handle_menu_response menu_response

  end

  private
  
  def retrieve_menu(date)
    menu_url = menu_url_for_date date
    return HTTP.get(menu_url)
  end

  def handle_menu_response(menu_response)
    if menu_response.status_code.between?(200, 299)
      @menu = JSON.parse menu_response.body

      prepare_menu @menu
    else
      not_found
    end
  end

  def menu_url_for_date(date)
    "http://appdev.grinnell.edu/glicious/#{date.month}-#{date.day}-#{date.year}.json"
  end

  def prepare_menu(menu)
    menu.delete("PASSOVER")
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
