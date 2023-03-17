############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("recordermodule")
#endregion


############################################################
import { send as tgSend } from "./telegrambotmodule.js"

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return

export track = (exchange, txObj) ->

        status = txObj.status
        vol = txObj.vol
        vol_exec = txObj.vol_exec

        price = txObj.price
        cost = txObj.cost
        fee = txObj.fee
        
        type = txObj.descr.type
        pair = txObj.descr.pair

        
        message = """
            Order Executed on #{exchange}!
            #{type} #{vol}BTC @ #{price}

            cost: #{cost}
            fee: #{fee}

            status: #{status}
            vol/vol_exec: #{vol}/#{vol_exec}
        """

        tgSend(message)
        return