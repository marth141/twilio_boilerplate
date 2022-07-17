# Twilio with Phoenix 1.6.x Liveview Example

## The important stuff
* [config/dev.secrets.exs](https://github.com/marth141/twilio_boilerplate/blob/master/config/dev.secrets.exs)
  * Where the secret auth tokens from Twilio get captured
  * Set as system envs e.g. `export TWILIO_ACCOUNT_SID = blahblahblah`
* [apps/phone/lib/phone.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/phone/lib/phone.ex)
  * Mostly provides twiml and access tokens with ex_twiml and ex_twilio respectively
* [apps/web/lib/web/router.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/router.ex)
  * Defines routes for Twilio's Twiml App or Phone Number Webhooks to POST to
* [apps/web/lib/web/controllers/twilio_controller.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/controllers/twilio_controller.ex)
  * Defines what to do with incoming Twilio POSTs
* [apps/web/assets/js/app.js](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/assets/js/app.js)
  * Imports the twilio.min.js from the @twilio/voice-sdk
  * Creates a Phone phoenix hook
  * Twilio device setup detailed
* [apps/web/lib/web/live/twilio_live/index.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/live/twilio_live/index.ex)
  * The liveview webpage controller adding state such as a phone number to dial and tokens
* [apps/web/lib/web/live/twilio_live/index.html.heex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/live/twilio_live/index.html.heex)
  * The webpage where magic happens

In Twilio's online console, for voice you can configure Voice Twiml App "request url" webhook or Phone Number "A call comes in" webhook.

The "Twiml App Request URL Webhook" is good for stuff where you have a webpage with a click to call button. The request will be handled by an endpoint on this server that returns Twiml. "twilio/api/dial" returns some dial Twiml.

The "A Call Comes in Webhook" is good for when you have a phone number that you want handled in some way by your server. For example, "twilio/api/ivr/welcome" will get someone to a phone tree for the "ET Phone Home Service".

Interesting ways of utilizing endpoints on the phone server emerge with the examples here.

## Why?
So I have been working at a solar company since 2020 and had been seeing tons of problems with their CRM stuff. I had figured that I could build my own CRM with a database and a server. However, one critical business piece for a lot of businesses is the phone system. They want voice and SMS. The voice part is tricky.

Daniel Berkompas has a library [ex_twilio](https://github.com/danielberkompas/ex_twilio) which details a way to use Twilio in a Phoenix application. What I wanted different though was not to use a CDN, to use modern phoenix hooks, and to use the latest Twilio at 2.x instead of 1.14. I had rolled my face on this for a while and here is now the finished prototype.
