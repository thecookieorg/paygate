# PayGate Ruby Library

The Paygate Ruby library provides convenient access to the [PayGate PayWeb 3 API](http://docs.paygate.co.za/#payweb-3) from applications written in the Ruby language.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paygate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paygate

## Process Flow

Process flow description:

1. The merchant begins the process by posting a detailed request to PayWeb.
2. PayWeb responds immediately with a unique `pay_request_id` field.
3. The merchant redirects the client to PayWeb and passes limited information incliding the `pay_request_id` field returned by PayWeb in step 1. PayWeb displays a meny of active payment methods to the client (if appropriate) and process the transaction to the relevant financial service provider.
4. PayWeb redirects the client back to the `return_url` provided by the merchant in step 1.

## Usage

The first step is to initiate the transaction.

```ruby
require 'paygate'

paygate_response = Paygate.initiate_transaction(
					paygate_id,
					encription_key,
					reference_number,
					amount,
					currency,
					return_url,
					locale,
					country,
					recepient,
					pay_method)
```

paygate_response will return two values:

1. pay_request_id
2. checksum_from_response

You will use both values in HTML form to redirect user to PayGate hosted page, where they can enter credit card information and finalize the payment.

Here is an example of the form:

```html
<form action="https://secure.paygate.co.za/payweb3/process.trans" method="POST">
  <input type="hidden" name="PAY_REQUEST_ID" value="#{@pay_request_id}" />
  <input type="hidden" name="CHECKSUM" value="#{@checkusm_from_response}" />
  <input type="submit" value="PAY NOW" className="button" />
</form>
```

After finalize the payment on PayGate hosted page, it will redirect them back to your application, to the page defined in `return_url`. If you have `paygate_result` page, add this to your routes: `post '/paygate_result' => 'pages#paygate_result'` and paygate will return 3 values to this page:

1. PAY_REQUEST_ID
2. TRANSACTION_STATUS
3. CHECKSUM.

You can define those in your controller like this:

```ruby
def paygate_result
    @pay_request_id = params[:PAY_REQUEST_ID]
    @transaction_status = params[:TRANSACTION_STATUS]
    @checksum = params[:CHECKSUM]
end
```

and use them in your `paygate_result` page to display status of the transaction.

## Fields explained

`paygate_id`: a unique ID obtained from PayGate (test value: 10011072130).
`encription_key`: password obtained by PayGate (test: secret).
`reference_number`: this is your reference number for use by your internal systems.
`amount`: transaction amount in cents. e.g. 32.99 is specified as 3299.
`currency`: currency code of the currency the customer is paying in. Refer to [Currency Codes](http://docs.paygate.co.za/#country-codes).
`return_url`: once the transaction is completed, PayWeb will return the customer to a page on your web site. The page the customer must see is specified in this field.
`locale`: the locale code identifies to PayGate the customer’s language, country and any special variant preferences (such as Date/Time format) which may be applied to the user interface. Please contact PayGate support to check if your locale is supported. If the locale passed is not supported, then PayGate will default to the “en” locale.
`country`: Country code of the country the customer is paying from. Refer to [Country Codes](http://docs.paygate.co.za/#country-codes).
`recepient`: if the transaction is approved, PayWeb will email a payment confirmation to this email address – unless this is overridden at a gateway level by using the Payment Confirmation setting. This field remains compulsory but the sending of the confirmation email can be blocked .
`pay_method`: Refer to [PAY_METHOD](http://docs.paygate.co.za/#payment-method-codes).

## Other

You can find official documentation for PayGate PayWeb 3 [here](http://docs.paygate.co.za/).
You can find more about error codes [here](http://docs.paygate.co.za/#error-codes).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/paygate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
