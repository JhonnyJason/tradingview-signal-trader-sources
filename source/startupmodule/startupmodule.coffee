############################################################
import * as sci from "./scimodule.js"
import * as exchanges from "./exchangeconnectionmodule.js" 
import * as service from "./servicefunctionsmodule.js"

############################################################
export serviceStartup = ->
    req = {body:{token:"deadbeefdeadbeefdeadbeefdeadbeef"}}
    res = {status: -> {send: -> return}}
    service.onSignal(req, res)
    sci.prepareAndExpose()
    return