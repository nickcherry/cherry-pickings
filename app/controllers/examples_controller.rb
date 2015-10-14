class ExamplesController < ApplicationController
  layout 'example'

  def index
    @example_id = "#{ name }-#{ instance }-example"
    @example_class = "#{ name }-example"
    render template
  end

protected

  def name
    @name ||= params[:name].parameterize
  end

  def instance
    @instance ||= params[:instance].parameterize
  end

  def template
    if shared_template?(name)
      "examples/#{ name.underscore }/index"
    else
      "examples/#{ name.underscore }/#{ instance.underscore }"
    end
  end

  def shared_template?(example_name)
    ['fade'].include? example_name
  end

end
