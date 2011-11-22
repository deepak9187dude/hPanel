#!/usr/bin/ruby


require "net/http"
require "net/https"
require "uri"
require "md5"



class Bluepay

  @@SERVER = "secure.bluepay.com"
  @@PATH = "/interfaces/bp20post"
  
  def initialize(account,key,mode='TEST')
    @ACCOUNT_ID = account
    @SECRET_KEY = key
    @PARAM_HASH = { 'MODE' => mode }
    @RETURN_HASH = Hash.new()
  end
  
  # used to set all other parameters... there's a lot of them.
  # See Bluepay20post.txt
  def set_param(key, val)
    @PARAM_HASH[key] = val
  end
  
  # Set up an ACH transaction.  Expects:
  # acc_type: C for Checking, S for Savings
  # routing: Bank routing number
  # account: Customer's checking or savings account number
  # doc_type: WEB, TEL, ARC, etc -- see docs.  Optional.
  # REMEMBER: Ach requires some other fields,
  # such as address and phone 
  def use_check(acc_type, routing, account, doc_type)
    @PARAM_HASH['PAYMENT_ACCOUNT'] = "#{acc_type}:#{routing}:#{account}"
    @PARAM_HASH['DOC_TYPE'] = doc_type
    @PARAM_HASH['PAYMENT_TYPE'] = "ACH"
  end

  # Set up a credit card payment.
  def use_card(account, expire, cvv)
    @PARAM_HASH['PAYMENT_ACCOUNT'] = account
    @PARAM_HASH['CARD_EXPIRE'] = expire
    @PARAM_HASH['CARD_CVV2'] = cvv
  end

  # Set up a sale
  def easy_sale(amount)
    @PARAM_HASH['TRANS_TYPE'] = 'SALE'
    @PARAM_HASH['AMOUNT'] = amount
  end

  # Set up an Auth-only
  def easy_auth(amount)
    @PARAM_HASH['TRANS_TYPE'] = 'AUTH'
    @PARAM_HASH['AMOUNT'] = amount
  end
  
  # Capture an auth
  def easy_capture(trans_id)
    @PARAM_HASH['TRANS_TYPE'] = 'CAPTURE'
    @PARAM_HASH['MASTER_ID'] = trans_id
  end

  # Refund
  def easy_refund(trans_id)
    @PARAM_HASH['TRANS_TYPE'] = 'REFUND'
    @PARAM_HASH['MASTER_ID'] = trans_id
  end

  # This is the important stuff to get 
  # the best rates on CC transactions.
  def customer_data(name1, name2, addr1, city, state, zip)
    @PARAM_HASH['NAME1'] = name1
    @PARAM_HASH['NAME2'] = name2
    @PARAM_HASH['ADDR1'] = addr1
    @PARAM_HASH['CITY'] = city
    @PARAM_HASH['STATE'] = state
    @PARAM_HASH['ZIP'] = zip
  end

  # Turns a hash into a foo=bar&baz=bat style string
  def uri_query(h)
    a = Array.new()
    h.each_pair {|key, val| a.push(URI.escape(key) + "=" + URI.escape(val)) }
    return a.join("&")
  end

  # Sets TAMPER_PROOF_SEAL in @PARAM_HASH
  def calc_tps()
    # Take the cheap way out.  I wrote bp20post and I hereby publically
    # state the TPS in bp20post is stupid.
    @PARAM_HASH["TPS_DEF"] = "HELLO_MOTHER" 
    @PARAM_HASH["TAMPER_PROOF_SEAL"] =  MD5.new(@SECRET_KEY).hexdigest
  end

  # Run a transaction - you must have called appropriate functions
  # to set the transaction type, etc before calling this.
  def process()
    ua = Net::HTTP.new(@@SERVER, 443)
    ua.use_ssl = true

    # Generate the query string and headers
    calc_tps()
    query = "ACCOUNT_ID=#{@ACCOUNT_ID}&"
    query += uri_query(@PARAM_HASH)
   
    queryheaders = {
      'User-Agent' => 'Bluepay Ruby Client',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    
    # Make Bluepay do Super CreditCard Magic
    headers, body = ua.post(@@PATH, query, queryheaders)

    # Split the response into the response hash.
    # Also, we stuff in RESPONSE_CODE expected to be 200 or 400...
    @RESPONSE_HASH = { "RESPONSE_CODE" => headers.code }
    body.split("&").each { |pair| 
      (key, val) = pair.split("=")
      val = "" if(val == nil)
      @RESPONSE_HASH[URI.unescape(key)] = URI.unescape(val) 
    }
  end

  # Returns ! on WTF, E for Error, 1 for Approved, 0 for Decline
  def get_status()
    return 'E' if(@RESPONSE_HASH['RESPONSE_CODE'] == 400)
    return '1' if(@RESPONSE_HASH['STATUS'] == '1');
    return '0' if(@RESPONSE_HASH['STATUS'] == '0');
    return 'E' if(@RESPONSE_HASH['STATUS'] == 'E');
    return '!'
  end

  # Returns the human-readable response from Bluepay.
  # Or a nasty error.
  def get_message()
    m = @RESPONSE_HASH['MESSAGE']
    if (m == nil or m == "")
      return "ERROR - NO MESSAGE FROM BLUEPAY"
    end
    return m
  end

  # Returns the single-character AVS response from the 
  # Card Issuing Bank
  def get_avs_code()
    return @RESPONSE_HASH['AVS']
  end

  # Same as avs_code, but for CVV2
  def get_cvv2_code()
    return @RESPONSE_HASH['CVV2']
  end

  # In the case of an approved transaction, contains the
  # 6-character authorization code from the processing network.
  # In the case of a decline or error, the contents may be junk.
  def get_auth_code()
    return @RESPONSE_HASH['AUTH_CODE']
  end

  # The all-important transaction ID.
  def get_trans_id()
    return @RESPONSE_HASH['TRANS_ID']
  end
    
  # If you set up a rebilling, this'll get it's ID.
   def get_rebill_id()
    return @RESPONSE_HASH['REBID']
  end

end







