Goldberg::Application.routes.draw do
  root :to => "home#index"

  get '/home/projects_partial' => 'home#projects_partial', :as => :projects_partial

  ['XmlStatusReport.aspx', 'cctray.xml', 'cc.xml'].each do |route|
    get route, :to => 'home#ccfeed', :defaults => {:format => 'xml'}
  end

  resources :projects, :only => 'index'

  get '/projects/:project_name' => 'projects#show', :as => :project
  post '/projects/:project_name/builds' => 'projects#force', :as => :project_force

  get '/projects/:project_name/builds/:build_number' => 'builds#show', :as => :project_build
  get '/projects/:project_name/builds/:build_number/log' => 'builds#log', :as => :project_build_log
  get '/projects/:project_name/builds/:build_number/artefacts/:path' => 'builds#artefact', :constraints => {:path => /.*/}, :as => :project_build_artefact
end
