require 'amount'
class ChargesController < ApplicationController

  before_action :check_if_already_premium, only: [:new, :create]

  def new
    key = "#{ Rails.configuration.stripe[:publishable_key] }"
    description = "BigMoney Membership - #{current_user.email}"
    @stripe_btn_data = {
     key: key,
     description: description,
     amount: Amount.default
   }
 end

  def create
    # Creates a Stripe Customer object, for associating
   # with the charge
   customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )

   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: Amount.default,
     description: "BigMoney Membership - #{current_user.email}",
     currency: 'usd'
   )

   flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
   current_user.premium!
   redirect_to root_path # or wherever

   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
  end

  def downgrade
    current_user.standard!
    flash[:alert] = "You canceled your subscription even though you had already paid!"
    redirect_to root_path
  end

  private
  def check_if_already_premium
    if current_user.premium?
      flash[:alert] = "You already paid and are premium!! No need to pay!"

      redirect_to root_path
    elsif current_user.admin?
      flash[:alert] = "You are an admin!! No need to pay!"
      redirect_to root_path
    end
  end

end
