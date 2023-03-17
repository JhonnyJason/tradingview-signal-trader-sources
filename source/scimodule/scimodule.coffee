############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
#region modules from the Environment
import * as sciBase from "thingy-sci-base"

############################################################
import * as cfg from "./configmodule.js"
import { onSignal, getStatus } from "./servicefunctionsmodule.js"

#endregion

############################################################
export prepareAndExpose = ->
    log "prepareAndExpose"
    restRoutes = {}
    
    routeName = cfg.get("webhookRoute")
    restRoutes[routeName] = onSignal
    # restRoutes["getStatus"] = getStatus

    sciBase.prepareAndExpose(null, restRoutes)
    
    return
