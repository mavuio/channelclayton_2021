import 'alpinejs'

import "phoenix_html"
import {
    Socket
} from "phoenix"
import NProgress from "nprogress"
import {
    LiveSocket
} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

import "regenerator-runtime/runtime.js";


const RootHook = {
    mounted() {
        this.handleEvent("root.console_log", (payload) => console.log(payload.msg, payload.data))
        this.handleEvent("root.console_error", (payload) => console.error(payload.msg, payload.data))
    },
};


const PhxContextHook = {
    mounted() {
        window.PhxContext = this
        const comps = this.el.querySelectorAll("[defer-x-data]")
        // console.log('#log 6788  mounted', comps);
        comps.forEach(comp => {
            comp.setAttribute('x-data', comp.getAttribute('defer-x-data'))
            comp.removeAttribute('defer-x-data')
            Alpine.initializeComponent(comp);
        });
    },
    updated() {
        const comps = this.el.querySelectorAll("[defer-x-data]")
        // console.log('#log 6788  update', comps);

        comps.forEach(comp => {
            comp.setAttribute('x-data', comp.getAttribute('defer-x-data'))
            comp.removeAttribute('defer-x-data')
            Alpine.initializeComponent(comp);
        });
    },
}


//mwuits:
window.Hooks = {
    PhxContextHook,
    RootHook,
};

if (typeof window.LocalHooks !== "undefined") {
    window.Hooks = {
        ...window.Hooks,
        ...window.LocalHooks,
    };
}



window["setWaiting"] = function (enable) {
    var container = document.getElementById("maincontent");
    if (enable) {
        NProgress.start();
        container.classList.add(["phx-disconnected"]);
    } else {
        NProgress.done();
        container.classList.remove([
            ["phx-disconnected"]
        ]);
    }
};


let liveSocket = new LiveSocket("/live", Socket, {
    dom: {
        onBeforeElUpdated(from, to) {
            if (from._x_dataStack) {
                window.Alpine.clone(from, to)
            }
        }
    },
    params: {
        _csrf_token: csrfToken
    },
    hooks: window.Hooks //mwuits
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
