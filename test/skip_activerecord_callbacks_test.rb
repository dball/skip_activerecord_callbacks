require 'test_helper'

class DestructionNotifier
  def self.product_was_destroyed(product)
  end
end

class Product < ActiveRecord::Base
  attr_accessible :name

  before_save do |product|
    product.name = 'bar'
  end

  after_save do |product|
    product.name = product.name.titleize
  end

  after_destroy do |product|
    DestructionNotifier.product_was_destroyed(product)
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

  describe "normal destroy" do
    it "destroys the model and runs the callbacks" do
      product.save
      DestructionNotifier.expects(:product_was_destroyed).with(product)
      product.destroy
      assert product.destroyed?
    end
  end

  describe "#destroy_without_callbacks" do
    it "destroys a record without running the callbacks" do
      product.save
      DestructionNotifier.expects(:product_was_destroyed).never
      product.destroy_without_callbacks
      assert product.destroyed?
    end
  end
end
