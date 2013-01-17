# TestActiveAdmin

Test Active Admin resources in your application. 

The gem extracts all Active Admin resources, creates the instances using 
[factory_girl](https://github.com/thoughtbot/factory_girl), 
and executes :index, :show, :edit actions for each resource.

## Installation

Add this line to your application's Gemfile:

    gem "test_active_admin", :git => "git://github.com/BrandyMint/test_active_admin.git"

And then execute:

    $ bundle

## Usage

Create `*_spec.rb` file (ex. `active_admin_spec.rb`) in `requests` group of specs 
(ex. `spec/requests` or `spec/acceptance`)

Define Active Admin tests in `active_admin_spec.rb`

    require 'spec_helper'
    require 'test_active_admin'
    
    # define active admin tests
    test_active_admin do |config|
      
      config.before do
        # code to be executed before each resource test
        stub_some_things
      end
      
      config.login do
        # code to login to active admin
        @admin_user = FactoryGirl.create(:admin_user)
        visit '/admin'
        fill_in 'admin_user_email', :with => @admin_user.email
        fill_in 'admin_user_password', :with => @admin_user.password
        click_button 'Login'
      end
      
    end

And now `active_admin_spec.rb` contains Capybara tests that can be runned.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
