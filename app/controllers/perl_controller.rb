class PerlController < ApplicationController
  def index
    render :text=> `perl #{Rails.root}/perls/datetime.pl param1`
  end
  def paypal
    pay_request = PaypalAdaptive::Request.new
      data = {
      "returnUrl" => "http://localhost:3000/payments/completed_payment_request", 
      "requestEnvelope" => {"errorLanguage" => "en_US"},
      "currencyCode"=>"USD",  
      "receiverList"=>{"receiver"=>[{"email"=>"deepak@idifysolutions.com", "amount"=>"10.00"}]},
      "cancelUrl"=>"http://localhost:3000/payments/canceled_payment_request",
      "actionType"=>"PAY",
      "ipnNotificationUrl"=>"http://localhost:3000/payments/ipn_notification"
      }
      pay_response = pay_request.pay(data)
      if pay_response.success?
        render :text=> pay_request.to_json + "<br><br><br>" +data.to_json
      else
        puts pay_response.errors.first['message']  
        render :text=> pay_request.to_json + "<br><br>" +data.to_json
      end
  end
end
