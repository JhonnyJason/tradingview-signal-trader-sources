############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("signalhandlermodule")
#endregion

############################################################
import * as exchange from "./exchangeconnectionmodule.js"
import { send as tgSend } from "./telegrambotmodule.js"
import * as c from "./configmodule.js"

############################################################
import * as data from "cached-persistentstate"

############################################################
IN = 1
OUT = 0

############################################################
s = null
############################################################
export initialize = ->
    log "initialize"
    await c.isReady()
    s = data.load("signalHandlerState")
    return

############################################################
export handleSignal = (signal) ->
    log "handleSignal"

    message = "Signal received!\n #{JSON.stringify(signal, null, 4)}"
    tgSend(message)

    olog s

    if signal.action == "sell" and s.inOrOut == IN
        exchange.sellAllAssets()
        s.inOrOut = OUT
    if signal.action == "buy" and s.inOrOut == OUT
        exchange.buyAllAssets()
        s.inOrOut = IN
    data.save("signalHandlerState")

    return



