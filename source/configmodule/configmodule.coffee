############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("configmodule")
#endregion

############################################################
# default config
allConfig = {
    authToken: "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    webhookRoute: "deadbeefdeadbeefdeadbeefdeadbeef"
    
    initialBagSize: 100
    maxBagSize: 300

    telegramToken: ""
    tekegranChatId: ""
}


############################################################
import fs from "fs"
import path from "path"

############################################################
readySignal = null
ready = new Promise((resolve) -> readySignal = resolve) 


############################################################
export initialize = ->
    log "initialize"
    configPathRelative = "../config.json"
    configFilePath = path.resolve(process.cwd(), configPathRelative)
    try
        log "reading config file"
        configFile = fs.readFileSync(configFilePath, "utf8")
        c = JSON.parse(configFile)
        allConfig[key] = prop for key,prop of c
    catch err then log("Error when reading config file: #{err.message}") 
    readySignal(true)
    return

#endregion

############################################################
export isReady = -> return ready
export get = (key) -> allConfig[key]
