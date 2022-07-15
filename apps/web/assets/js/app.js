// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import('@twilio/voice-sdk/dist/twilio.min.js')

let Hooks = {}

Hooks.Phone = {
    number() { return this.el.dataset.number },
    token() { return this.el.dataset.token },
    queue() { return this.el.dataset.queue },
    mounted() {
        /* Set up Twilio device with token */
        const Device = new Twilio.Device(this.token())
        /* Let us know when the client is ready. */
        Device.addListener("registered", function (device) {
            $("#log").text("Ready");
        });
        /* Report any errors on the screen */
        Device.addListener("error", function (error) {
            $("#log").text("Error: " + error.message);
        });
        /* Handle when a call is incoming */
        Device.addListener("incoming", function (call) {
            $("#log").text("Incoming connection from " + call.parameters.From);
            call.accept()
        })
        /* Registers twilio device */
        Device.register()
        /* Adds click event listener to call button */
        document.getElementById("call").addEventListener("click", e => {
            Device.connect({ params: { dial: this.number() } });
        })
        /* Adds click event listener to hangup button */
        document.getElementById("hangup").addEventListener("click", e => {
            Device.disconnectAll();
        })
        /* Adds click event listener to work queue button */
        document.getElementById("work-queue").addEventListener("click", e => {
            Device.connect({ params: { dial: this.queue() } });
        })
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

