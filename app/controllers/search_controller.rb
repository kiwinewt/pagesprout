# Author::    Rocket Boys  (mailto: rocketboys at rocketboys dot co dot nz)
# Copyright:: Copyright (c) 2008 Rocket Boys Ltd
# License::   BSD Licence, see application root.

# This class takes care of the site searching
class SearchController < ApplicationController

  # Handle requests from the search box/form, process them then display the results in a page.
  # Requres Ferret and acts_as_ferret.
  def search
    if params[:query].present?
      @query = params[:query]
      @results = Page.enabled.find_by_contents(@query, { :multi => [Post, Blog] })
    end
  end
end
