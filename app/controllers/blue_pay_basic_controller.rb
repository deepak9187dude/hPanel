class BluePayBasicController < ApplicationController
             
        require 'Bluepay'
        
        def DoBluePayPayment
            #invoice = params[:invoice_details]
             
            accountId = get_gateway_settings('gateway_login', 2) #ACCOUNT_ID
            secretKey = get_gateway_settings('gateway_key', 2) #SECRET_KEY
           
            bpApi = Bluepay.new('100055017580', 'X403IXYR3M2Q2DNEZQ56CWOOF4XMOJQK')
            bpApi.customer_data("Pardeep","Dhingra","Town","Hall","NY","ad4512")
            bpApi.use_card("4111111111111111", "1013", "112")
            bpApi.easy_sale("1")

            bpApi.process()

            puts "Status: " + bpApi.get_status()
            puts "Message: " + bpApi.get_message()
           puts "Transaction ID: " + bpApi.get_trans_id()
            render :text=> "Status: " + bpApi.get_status() + "</br> Message: " +bpApi.get_message() + ":" + bpApi.get_trans_id()
        end

        def get_gateway_settings(field,gateway_id)
            gateway_field = Gateway.find(gateway_id,:select=>field)
            return gateway_field
        end
        
end
