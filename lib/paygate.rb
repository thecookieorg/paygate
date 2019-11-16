require "paygate/version"
require "httparty"
require 'digest/md5'

module Paygate
  class Error < StandardError; end

  def self.initiate_transaction(paygate_id, encription_key, reference_number, amount, currency, return_url, locale, country, recepient, pay_method)
    d = DateTime.now
    current_time = d.strftime("%Y-%m-%d %H:%M:%S")
    
    data = {
      PAYGATE_ID: paygate_id,
      REFERENCE: "#{reference_number}",
      AMOUNT: amount.to_i * 100,
      CURRENCY: currency,
      RETURN_URL: "#{return_url}",
      TRANSACTION_DATE: current_time,
      LOCALE: "#{locale}",
      COUNTRY: "#{country}",
      EMAIL: "#{recepient}",
      PAY_METHOD: "#{pay_method}"
    }

    a = data.map{|k,v| "#{v}"}.join('')

    checksum = Digest::MD5.hexdigest("#{a}#{encription_key}")

    data[:CHECKSUM] = checksum
    fields_string = data.to_query

    response = HTTParty.post("https://secure.paygate.co.za/payweb3/initiate.trans", {
      body: fields_string,
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'charset' => 'utf-8'
      }
    })

    pay_request_id = response.split("&PAY_REQUEST_ID=")[1].split("&REFERENCE")[0]
    checkusm_from_response = response.split("&CHECKSUM=")[1]
    
    paygate_response = {
      :pay_request_id => pay_request_id,
      :checkusm_from_response => checkusm_from_response
    }


  end # end method

end