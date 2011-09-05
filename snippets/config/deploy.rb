# deploy:cm

# Env setup
server "ragnarok", :app, :db, :primary => true

set :application   , "snippets"
set :user          , "diego"
set :port          , 22
set :deploy_to     , "/unesp/#{application}"   
set :shared_path      , "#{deploy_to}"

set :keep_releases    , 5
set :use_sudo         , false

set :scm           , :git
set :repository    , "git@diegorubin.com:unesp/miaweb.git"

set :static_path   , "/unesp/static/ia"
set :assets_path   , "/unesp/assets/ia"

default_environment["PATH"] = "/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/opt/ree/bin"
# }

# Task chaining {

after   "deploy:setup"            , "deploy:setup_dir"
before  "deploy:update"           , "deploy:set_branch_name"
after   "deploy:update_code"      , "deploy:copy_config_files"
after   "deploy:finalize_update"  , "deploy:relink"
before  "deploy:symlink"          , "deploy:check_environment"
after   "deploy"                  , "deploy:cleanup"

# }

# Capistrano Tasks
namespace :deploy do

  desc "[internal] Setup: complementary dirs"
  task :setup_dir do
    run <<-CMD
      [ -d "#{shared_path}/bundle"     ] || mkdir -p #{shared_path}/bundle
    CMD
  end

  desc "[internal] Set a branch/tag or SHA1"
  task :set_branch_name do
    set :branch, (ENV['TAG'] || ENV['BRANCH'] || _get_branch_name)
  end

  desc "[internal] Relink"
  task :relink do
    _relink_to( :inside => "#{latest_release}/public" , :my_dir => "assets" , :link_to => "#{assets_path}" )
    _relink_to( :inside => "#{latest_release}/public" , :my_dir => "static" , :link_to => "#{static_path}" )
  end

  desc "[internal] Check environment before symlink"
  task :check_environment, :except => { :no_release => true } do # on_rollback { run "/bin/rm -rf #{current_release}; true" }
    ### Rails 2.3
  # run "cd #{current_release} && RAILS_ENV=production ./script/runner 'puts \"Check environment:\", Rails.env'"

    ### Rails 3
  # run "cd #{current_release} && RAILS_ENV=prodcution bundle exec rails runner 'puts \"Check environment:\", Rails.env'"
  end

  desc "[internal] Copy config files to current_release"
  task :copy_config_files do
    run "/bin/cp #{shared_path}/config/*.yml             #{current_release}/config/"
    run "/bin/cp #{shared_path}/config/production.rb     #{current_release}/config/environments/"
  end

 desc "Restarting passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run  "mkdir -p #{current_path}/tmp && touch #{current_path}/tmp/restart.txt"
  end

 end

# Branch/Tag/SHA1 {

def _get_branch_name
  print "\n  * ", "-" * 50, "\n"
  puts "    Deploy: Type branch name, tag name or SHA1. Default: [ master ]"
  branch_name = Capistrano::CLI.ui.ask('')
  branch_name = 'master' if branch_name == ''
  puts "    Deploying: [ #{branch_name} ]\n"
  print "  * ", "-" * 50, "\n"
end

# }

# link to dir, if exists {
def _relink_to( param )
  run <<-CMD
    cd #{param[:inside]} ;
    if [ -s #{param[:link_to]} ];
    then /bin/rm -rf #{param[:my_dir]} && ln -s #{param[:link_to]} #{param[:my_dir]} ;
    fi
  CMD
end

# }

# copy/create config file {
def _copy_config( param )
  # 1: create shared_path/config, if not exists
  run <<-CMD
    if [ ! -d #{shared_path}/config ] ; then mkdir #{shared_path}/config ; fi;

    if [ -f      #{shared_path}/config/#{param[:file]} ];
    then /bin/cp #{shared_path}/config/#{param[:file]} #{param[:to]};
    else echo "NOT FOUND: #{param[:file]}";
    fi
  CMD
  # 2.1:  use shared_path/config file
  # 2.2:   no shared_path/config file: create new one from release
  # 2.3:                               create new one from release sample
    # else if [ -f      #{param[:to]}/#{param[:file]} ];
    #      then /bin/cp #{param[:to]}/#{param[:file]} #{shared_path}/config;
    #      fi;
    #      if [ -f      #{param[:to]}/#{param[:file]}.sample ];
    #      then /bin/cp #{param[:to]}/#{param[:file]}.sample #{shared_path}/config/#{param[:file]};
    #      fi;
end

# }


# vim:ft=ruby:

