# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'minitest/autorun'
require 'mocha/integration/mini_test'

Rails.backtrace_cleaner.remove_silencers!

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Base.class_eval do
  silence do
    connection.create_table :products, :force => true do |t|
      t.column :name, :string
    end
  end
end

class UnitTest < MiniTest::Spec
  register_spec_type(//, self)
end
