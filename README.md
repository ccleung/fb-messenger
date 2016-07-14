# Overview

This gem uses the [facebook (fb) messenger API](https://developers.facebook.com/docs/messenger-platform/send-api-reference) to send and receive facebook messages. Note that you will need to configure a [webhook URL](https://developers.facebook.com/docs/messenger-platform/webhook-reference) in your web app to which facebook messages will be posted. Please go through the [getting started guide](https://developers.facebook.com/docs/messenger-platform/quickstart) for setting up facebook messenger API, which is a pre-requisite step for using this gem.

# Usage

The following steps uses a rails setup, but the gem can be used in any ruby web framework that is capable of creating an API endpoint for the configured webhook.

1. Add the following to an initializer `config/initializers/<name>.rb` to setup your [fb access token](https://developers.facebook.com/docs/messenger-platform/quickstart) and [fb verify token](https://developers.facebook.com/docs/messenger-platform/quickstart)
   ```ruby
   require 'fb/messenger'
   
   Fb::Messenger.configure do |config|
     config.access_token = 'FB_MESSENGER_ACCESS_TOKEN'
     config.verify_token = 'FB_MESSENGER_VERIFY_TOKEN'
   end
   ```

2. Ensure that you have subscribers for each of the messenger [webhook events](https://developers.facebook.com/docs/messenger-platform/webhook-reference), namely 'message', 'postback', and 'deliver', e.g., add the following to the same `config/initializers/<name>.rb` file:
   ```ruby
   Fb::Messenger::Receiver.configure do |receiver|
     receiver.subscribe 'message', MsgSubscriber.new
     receiver.subscribe 'postback', PostBackSubscriber.new
     receiver.subscribe 'delivery', DeliverySubscriber.new
   end
   ```
   
   Where the classes `MsgSubscriber`, `PostBackSubscriber`, and `DeliverSubscriber` (arbitary class names) implements a `call` method seen in [Fb::Messenger::Subscriber::Base](https://github.com/ccleung/fb-messenger/blob/master/lib/fb/messenger/subscribers/base.rb)
   
   Usually in the `call` method, you would use the `Fb::Messenger::Client` to create reply message back to the sender.

3. In `routes.rb` specify two endpoints, one for verifying the webhook and one for handling webhook POST requests, e.g.,
   ```ruby
   Rails.application.routes.draw do
     get 'facebook/webhook' => 'facebook#verify'
     post 'facebook/webhook' => 'facebook#webhook'
   end
   ```

4. In the corresponding controller that implements the webhook add the following:
   ```ruby
   def webhook
     Fb::Messenger::Receiver.receive(params[:entry])
     head 200
   end
   ```
   
   Note that you need to return 2XX to indicate that you have received the message. To implement the `verify` controller action method for this example, please see the fb messenger [getting started guide](https://developers.facebook.com/docs/messenger-platform/quickstart).

# Sending messages

In the following examples, `id` can represent different types of facebook id's, such as page id's or user id's (see: https://developers.facebook.com/docs/messenger-platform/send-api-reference)

Send [Text Messages](https://developers.facebook.com/docs/messenger-platform/send-api-reference/text-message):

```ruby
Fb::Messenger::Client.send_message_text(id, "your message here")
```

Send [Generic Template Messages](https://developers.facebook.com/docs/messenger-platform/send-api-reference/generic-template):

```ruby
item = Fb::Messenger::Template::GenericItem.new
item.title = 'title'
item.subtitle = '...'
item.image_url = '...'

button = Fb::Messenger::Template::Button.new
# see: https://developers.facebook.com/docs/messenger-platform/send-api-reference/button-template
button.type = 'postback'
button.title = '...'
# this can be a json string that your Subscriber for postback must handle
button.payload = '...'

# you can add multiple buttons
item.buttons << button

generic = Fb::Messenger::Template::Generic
# you can add multiple generic items
generic.generic_items << item

template_msg = generic.template
Fb::Messenger::Client.send_message_template(id, template_msg)
```

Send [Receipt Template Messages](https://developers.facebook.com/docs/messenger-platform/send-api-reference/receipt-template):

```ruby
Fb::Messenger::Client.send_message_text(id, "your message here")
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

