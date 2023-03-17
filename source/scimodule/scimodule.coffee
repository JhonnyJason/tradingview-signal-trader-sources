############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
#region modules from the Environment
import * as sciBase from "thingy-sci-base"

############################################################
import * as c from "./configmodule.js"
import { onSignal, getStatus } from "./servicefunctionsmodule.js"

#endregion

############################################################
export prepareAndExpose = ->
    log "prepareAndExpose"
    
    routeName = c.get("webhookRoute")
    restRoutes = {}
    restRoutes[routeName] = onSignal
    restRoutes["getStatus"] = getStatus
    
    sciBase.prepareAndExpose(null, restRoutes)
    
    return