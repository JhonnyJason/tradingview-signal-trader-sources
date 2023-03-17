############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("servicefunctionsmodule")
#endregion

############################################################
import * as signalHandler from "./signalhandlermodule.js"
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
isAuthorized = (req) ->
    if typeof req.body  != "object" then return false
    if !req.body.token then return false
    if req.body.token != authToken then return false
    return true

emulate404 = (req, res)->
    route = req.path
    msgHTML = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <title>Error</title>
        </head>
        <body>
        <pre>Cannot POST /#{route}</pre>
        </body>
        </html>
    """
    res.status(404).send(msgHTML)
    return

############################################################
export onSignal = (req, res) ->
    log "onSignal"
    if !isAuthorized(req) then return emulate404(req, res)
    log "successfully authorized"
    olog req.body
    signalHandler.handleSignal(req.body)
    return res.status(202).send("")

############################################################
export getStatus = (req, res) ->
    log "getStatus"
    if !isAuthorized(req) then return res.status(401).send("")
    log "successfully authorized"
    olog req.body
    ## TODO implement
    serverStatus = {
        everything: "alright"
    }
    return res.send(serverStatus)

