class App < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::Reloader

  HTML_PATTERN = %r{^/(.*)\.html$}

  def haml_render(file, option = {})
    admin_dir = option[:admin] ? 'admin/' : ''
    layout = option[:admin] ? :admin_layout : :layout
    haml :"#{ admin_dir }#{ file }", layout: layout
  end

  namespace '/admin' do
    get HTML_PATTERN do
      haml_render params[:captures].first, admin: true
    end
  end

  get HTML_PATTERN do
    haml_render params[:captures].first
  end

  get %r{^/(stylesheets|javascripts)/(.*)\.(css|js)$} do
    dir = params[:captures][0] == 'stylesheets' ? 'scss' : 'coffee'
    file = params[:captures][1]
    method = params[:captures][2] == 'css' ? :scss : :coffee
    send(method, :"#{ dir }/#{ file }")
  end
end
