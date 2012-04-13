require 'test_helper'

class Product < ActiveRecord::Base
  attr_accessible :name

  before_save do |product|
    product.name = 'bar'
  end

  after_save do |product|
    product.name = product.name.titleize
  end
end

describe SkipActiverecordCallbacks do
  let(:product) { Product.new(:name => 'foo') }

  describe "normal save" do
    it "sets the product name to 'Bar'" do
      product.save
      product.name.must_equal 'Bar'
      product.new_record?.must_equal false
    end
  end

  describe "#update_without_callbacks" do
    it "saves a record without running its save callbacks" do
      product.update_without_callbacks
      product.name.must_equal 'foo'
      product.new_record?.must_equal false
    end

    it "updates a record without running its save callbacks" do
      product.save
      product.name = 'foo'
      product.update_without_callbacks
      product.name.must_equal 'foo'
      product.new_record?.must_equal false
    end

    it "restores the callbacks afterwards" do
      product.update_without_callbacks
      product.save
      product.name.must_equal 'Bar'
    end
  end
end
