############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("exchangeconnectionmodule")
#endregion

############################################################
import { Spot } from "@binance/connector"
import KrakenClient from "kraken-api"

############################################################
import * as c from "./configmodule.js"
import * as recorder from "./recordermodule.js"


############################################################
krakenClient = null
krakenBag = 0
krakePairId = "XXBTZEUR"
krakenPriceBTCEUR = 25000.0

binanceClient = null
binanceBag = 0
binancePairId = ""

initialBagSize = 0
maxBagSize = 0

############################################################
export initialize = ->
    log "initialize"
    await c.isReady()
    initialBagSize = c.get("initialBagSize")
    maxBagSize = c.get("maxBagSize") 

    apiKey = c.get("krakenKey")
    apiSecret = c.get("krakenSecret")
    if apiKey and apiSecret
        krakenClient = new KrakenClient(apiKey, apiSecret)
        krakenBag = initialBagSize

    apiKey = c.get("binanceKey")
    apiSecret = c.get("binanceSecret")
    if apiKey and apiSecret
        binanceClient = new Spot(apiKey, apiSecret)
        binanceBag = initialBagSize
    return


############################################################
buyOnKraken = ->
    return unless krakenClient?
    log "buyOnKraken"
    log "not executed!"
    return

    volume = 1.0 * krakenBag / krakenPriceBTCEUR
    
    pair = krakePairId
    type = "buy"
    ordertype = "market"
    volume = volume.toFixed(8)
    data = { pair, type, ordertype, volume }
    try
        response = await krakenClient.api("AddOrder", data)
        olog response
        if response.error? and response.error.length > 0
            throw JSON.stringify(response.error, null, 4)
        transactions = result.txid
        transactionId = transactions[0]
        if !transactionId and typeof transactionId != "string"
            throw new Error("Unexpected TransactionId!")
    
        txid = transactionId
        # # "O7PUC6-SJHUW-FOMDUZ"
        # # "OSACNP-ZDWVD-MFG5TQ"
        # txid = "O5U7ZT-EQ23D-CT4GF7"
        data = { txid }
        response = await krakenClient.api("QueryOrders", data)
        olog response
        if response.error? and response.error.length > 0
            throw JSON.stringify(response.error, null, 4)
        
        result = response.result
        if !result[txid]? then throw new Error("Queried transactionId did not exist!")

        recorder.track("kraken", result[txid])
    catch err then log err
    return

sellOnKraken = ->
    return unless krakenClient?
    log "sellOnKraken"
    log "not executed!"
    return
    volumeBTC = 1.0 * krakenBag / krakenPriceBTCEUR

    pair = krakePairId
    type = "sell"
    ordertype = "market"
    volume = volumeBTC.toFixed(8)
    data = { pair, type, ordertype, volume }

    try
        response = await krakenClient.api("AddOrder", data)
        olog response
        if response.error? and response.error.length > 0
            throw JSON.stringify(response.error, null, 4)
        transactions = result.txid
        transactionId = transactions[0]
        if !transactionId and typeof transactionId != "string"
            throw new Error("Unexpected TransactionId!")
    
        txid = transactionId
        # # "O7PUC6-SJHUW-FOMDUZ"
        # # "OSACNP-ZDWVD-MFG5TQ"
        # txid = "O5U7ZT-EQ23D-CT4GF7"
        data = { txid }
        response = await krakenClient.api("QueryOrders", data)
        olog response
        if response.error? and response.error.length > 0
            throw JSON.stringify(response.error, null, 4)
        
        result = response.result
        if !result[txid]? then throw new Error("Queried transactionId did not exist!")

        recorder.track("kraken", result[txid])

    catch err then log err
    return


############################################################
buyOnBinance = ->
    log "buyOnBinance"
    log "not implemented yet!"
    ## TODO implement
    return

sellOnBinance = ->
    log "sellOnBinance"
    log "not implemented yet!"
    ## TODO implement
    return

############################################################
export prepareConnections = ->
    log "prepareConnections"
    return

############################################################
export buyAllAssets = ->
    log "buyAllAssets"
    buyOnKraken()
    buyOnBinance()
    return

############################################################
export sellAllAssets = ->
    log "sellAllAssets"
    sellOnKraken()
    sellOnBinance()
    return