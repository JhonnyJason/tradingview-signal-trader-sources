import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug =

    configmodule: true
    scimodule: true
    servicefunctionsmodule: true
    signalhandlermodule: true
    
addModulesToDebug(modulesToDebug)