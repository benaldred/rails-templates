# based on daring.rb and bort.rb
# by Ben Aldred


# blanc.rb
# -----------------------
# Extra features
# - adds a custom css framework cloned from github


# Delete unnecessary files
  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
  run "rm -f public/javascripts/*"
  run "rm -f public/images/*"

# Download JQuery
  run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"

# Set up git repository
  git :init
  git :add => '.'
  
# Copy database.yml for distribution use
  run "cp config/database.yml config/database.yml.example"
  
# Set up .gitignore files
  run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
  run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
  file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

# Setup Rspec
  plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true
  generate("rspec")

# Other useful plugins
plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git', :submodule => true
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true

# useful gems
gem 'rubyist-aasm'


# Authentication?
if yes?("Do you want user authentication?")
  plugin 'restful_authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
  plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true
  plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
  gem 'ruby-openid', :lib => 'openid'
end

# clone custom css framework
  inside('public/stylesheets') do
    run 'git clone git://github.com/benaldred/blui.git'
    #clean up blui clone 
    run "cp -R blui/stylesheets/* ."
    run "rm -rf blui"
    run "rm -rf .git"
  end

  
  
# Capify
capify!
  
# Install gems and run rake tasks
  rake('gems:install', :sudo => true)

 
# Initialize submodules
  git :submodule => "init"

# Commit all work so far to the repository
  git :add => '.'
  git :commit => "-a -m 'Initial commit'"

# Success!
  puts "Done!"
  puts ""
  puts ""
  puts "Remember"
  puts "---------"
  puts ""
  puts "If you added user authentication"
  puts "* Generate the user authentication"
  puts "* Generate open id authentication"
  puts ""
  puts "* Run migrations"
  puts ""
  puts ""