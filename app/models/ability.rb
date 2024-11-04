# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :admin
    end

    if user.customer?
      can [ :index, :show, :create, :new, :update, :destroy ], :product
      can [ :index, :show, :payment_page, :checkout, :create, :destroy ], :order
      can :manage, :lineitem
      can :manage, :cart
      can :manage, :address
    end

    if user.seller?
      can :manage, :seller
      can [ :order_requests, :approve, :seller_cancel ], :order
    end
  end
end
