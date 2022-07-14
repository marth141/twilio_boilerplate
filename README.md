# Twilio Example

## The important stuff
* apps/phone/lib/phone.ex
  * Mostly provides twiml and access tokens with ex_twilio and ex_twiml
* apps/web/lib/web/router.ex
  * Defines routes for Twilio's Twiml App or Phone Number Webhooks to POST to
* apps/web/lib/web/controllers/twilio_controller.ex
  * Defines what to do with incoming Twilio POSTs
* apps/web/assets/js/app.js
  * Imports the twilio.min.js from the @twilio/voice-sdk
  * Creates a Phone phoenix hook
  * Twilio device setup detailed
* apps/web/lib/web/live/twilio_live/index.ex
  * The liveview controller adding state such as a phone number to dial and tokens
* apps/web/lib/web/live/twilio_live/index.html.heex
  * The webpage where magic happens
