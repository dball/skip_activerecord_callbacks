require 'test_helper'

class Notifier
  def self.product_was_saved(product)
  end

  def self.product_was_updated(product)
  end

  def self.product_was_created(product)
  end

  def self.product_was_destroyed(product)
  end
end

class Product < ActiveRecord::Base
  after_save do |product|
    Notifier.product_was_saved(product)
  end

  after_update do |product|
    Notifier.product_was_updated(product)
  end

  after_create do |product|
    Notifier.product_was_created(product)
  end

  after_destroy do |product|
    Notifier.product_was_destroyed(product)
  end
end

describe SkipActiverecordCallbacks do
  let(:product) { Product.new }

  describe "#update_without_callbacks" do
    describe "on create" do
      it "saves the record" do
        product.update_without_callbacks
        product.new_record?.must_equal false
      end

      it "skips the :save callbacks" do
        Notifier.expects(:product_was_saved).never
        product.update_without_callbacks
      end

      it "skips the :create callbacks" do
        Notifier.expects(:product_was_created).never
        product.update_without_callbacks
      end
    end

    describe "update" do
      before do
        product.save
        product.name = 'foo'
      end

      it "saves the record" do
        product.update_without_callbacks
        product.changes.empty?.must_equal true
      end

      it "skips the :save callbacks" do
        Notifier.expects(:product_was_saved).never
        product.update_without_callbacks
      end

      it "skips the :update callbacks" do
        Notifier.expects(:product_was_updated).never
        product.update_without_callbacks
      end
    end

    it "restores the callbacks afterwards" do
      product.update_without_callbacks
      Notifier.expects(:product_was_saved).with(product)
      product.save
    end
  end

  describe "#destroy_without_callbacks" do
    before do
      product.save
    end

    it "destroys the model" do
      product.destroy_without_callbacks
      product.destroyed?.must_equal true
    end

    it "skips the :destroy callbacks" do
      Notifier.expects(:product_was_destroyed).never
      product.destroy_without_callbacks
    end
  end
end
