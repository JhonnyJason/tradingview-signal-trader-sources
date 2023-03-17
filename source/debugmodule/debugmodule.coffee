import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug =

    configmodule: true
    exchangeconnectionmodule: true
    recordermodule: true
    scimodule: true
    servicefunctionsmodule: true
    signalhandlermodule: true
    
addModulesToDebug(modulesToDebug)