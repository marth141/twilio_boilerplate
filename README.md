# Twilio Phoenix 1.6.x Liveview Example

## The important stuff
* [apps/phone/lib/phone.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/phone/lib/phone.ex)
  * Mostly provides twiml and access tokens with ex_twilio and ex_twiml
* [apps/web/lib/web/router.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/router.ex)
  * Defines routes for Twilio's Twiml App or Phone Number Webhooks to POST to
* [apps/web/lib/web/controllers/twilio_controller.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/controllers/twilio_controller.ex)
  * Defines what to do with incoming Twilio POSTs
* [apps/web/assets/js/app.js](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/assets/js/app.js)
  * Imports the twilio.min.js from the @twilio/voice-sdk
  * Creates a Phone phoenix hook
  * Twilio device setup detailed
* [apps/web/lib/web/live/twilio_live/index.ex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/live/twilio_live/index.ex)
  * The liveview controller adding state such as a phone number to dial and tokens
* [apps/web/lib/web/live/twilio_live/index.html.heex](https://github.com/marth141/twilio_boilerplate/blob/master/apps/web/lib/web/live/twilio_live/index.html.heex)
  * The webpage where magic happens

## Why?
So I have been working at a solar company since 2020 and had been seeing tons of problems with their CRM stuff. I had figured that I could build my own CRM with a database and a server. However, one critical business piece for a lot of businesses is the phone system. They want voice and SMS. The voice part is tricky.

Daniel Berkompas has a library [ex_twilio](https://github.com/danielberkompas/ex_twilio) which details a way to use Twilio in a Phoenix application. What I wanted different though, was not to use a CDN, to use modern phoenix hooks, and to use the latest Twilio at 2.x instead of 1.14. I had rolled my face on this for a while and here is now the finished prototype.
