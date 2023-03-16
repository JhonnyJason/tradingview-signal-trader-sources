############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servicefunctionsmodule")
#endregion

############################################################
import * as c from "./configmodule.js"

############################################################
authToken = ""

############################################################
export initialize = ->
    log "initialize"
    await c.isReady()
    authToken = c.get("authToken")
    return

############################################################
isAuthorized = (res) ->
    log "isAuthorized"    
    olog res.body
    olog { authToken }
    if typeof res.body  != "object" then return false
    if !res.body.token then return false
    if res.body.token != authToken then return false
    return true


############################################################
export onSignal = (req, res) ->
    log "onSignal"
    if !isAuthorized(req) then return res.status(401).send("")
    log "successfully authorized"
    ## TODO implement
    return res.status(202).send("")