############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("signalhandlermodule")
#endregion

############################################################
import { send as tgSend } from "./telegrambotmodule.js"

############################################################
export handleSignal = (signal) ->
    log "handleSignal"
    message = "Signal received!\n #{JSON.stringify(signal, null, 4)}"
    tgSend(message)
    
    ## TODO implement
    return



