############################################################
import * as sci from "./scimodule.js"
import * as exchanges from "./exchangeconnectionmodule.js" 

############################################################
export serviceStartup = ->
    await exchanges.prepareConnections()
    sci.prepareAndExpose()
    return