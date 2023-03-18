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
binancePairId = "BTCUSDT"
binancePriceBTCEUR = 25000.0

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
    # log "not executed!"
    # return

    volumeBTC = 1.0 * krakenBag / krakenPriceBTCEUR
    
    pair = krakePairId
    type = "buy"
    ordertype = "market"
    volume = volumeBTC.toFixed(8)
    data = { pair, type, ordertype, volume }
    try
        response = await krakenClient.api("AddOrder", data)
        olog response
        if response.error? and response.error.length > 0
            throw JSON.stringify(response.error, null, 4)
        
        result = response.result
        transactionId = result.txid[0]
        if !transactionId and typeof transactionId != "string"
            throw new Error("Unexpected TransactionId!")
    
        txid = transactionId
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
    # log "not executed!"
    # return

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

        result = response.result
        transactionId = result.txid[0]
        if !transactionId and typeof transactionId != "string"
            throw new Error("Unexpected TransactionId!")
    
        txid = transactionId
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

    volumeBTC = 1.0 * binanceBag / binancePriceBTCEUR 
    
    pair = binancePairId
    type = "BUY"
    ordertype = "MARKET"
    quantity = volumeBTC.toFixed(8)
    data = { quantity }

    try
        response = await binanceClient.newOrder(krakePairId, type, ordertype, data)
        olog response
        # {
        # "symbol": "BTCUSDT",
        # "orderId": 28,
        # "orderListId": -1,
        # "clientOrderId": "6gCrw2kRUAF9CvJDGP16IP",
        # "transactTime": 1507725176595
        # }

        orderId = response.orderId
        data = { orderId }
        response = await binanceClient.getOrder(pair, data)
        olog response
        # {
        #     "symbol": "LTCBTC",
        #     "orderId": 1,
        #     "orderListId": -1,
        #     "clientOrderId": "myOrder1",
        #     "price": "0.1",
        #     "origQty": "1.0",
        #     "executedQty": "0.0",
        #     "cummulativeQuoteQty": "0.0",
        #     "status": "NEW",
        #     "timeInForce": "GTC",
        #     "type": "LIMIT",
        #     "side": "BUY",
        #     "stopPrice": "0.0",
        #     "icebergQty": "0.0",
        #     "time": 1499827319559,
        #     "updateTime": 1499827319559,
        #     "isWorking": true,
        #     "origQuoteOrderQty": "0.00000000"
        # }

        status = response.status
        price = response.price
        vol = response.origQty
        vol_exec = response.executedQty
        cost = "unknown"
        fee = "unknown"

        txObj = { status, vol, vol_exec, price, cost, fee, type, pair }

        recorder.track("binance", txObj)

    catch err then log err
    return

sellOnBinance = ->
    log "sellOnBinance"

    volumeBTC = 1.0 * binanceBag / binancePriceBTCEUR 
    
    pair = binancePairId
    type = "SELL"
    ordertype = "MARKET"
    quantity = volumeBTC.toFixed(8)
    data = { quantity }

    try
        response = await binanceClient.newOrder(krakePairId, type, ordertype, data)
        olog response
        # {
        # "symbol": "BTCUSDT",
        # "orderId": 28,
        # "orderListId": -1,
        # "clientOrderId": "6gCrw2kRUAF9CvJDGP16IP",
        # "transactTime": 1507725176595
        # }

        orderId = response.orderId
        data = { orderId }
        response = await binanceClient.getOrder(pair, data)
        olog response
        # {
        #     "symbol": "LTCBTC",
        #     "orderId": 1,
        #     "orderListId": -1,
        #     "clientOrderId": "myOrder1",
        #     "price": "0.1",
        #     "origQty": "1.0",
        #     "executedQty": "0.0",
        #     "cummulativeQuoteQty": "0.0",
        #     "status": "NEW",
        #     "timeInForce": "GTC",
        #     "type": "LIMIT",
        #     "side": "BUY",
        #     "stopPrice": "0.0",
        #     "icebergQty": "0.0",
        #     "time": 1499827319559,
        #     "updateTime": 1499827319559,
        #     "isWorking": true,
        #     "origQuoteOrderQty": "0.00000000"
        # }

        status = response.status
        price = response.price
        vol = response.origQty
        vol_exec = response.executedQty
        cost = "unknown"
        fee = "unknown"

        txObj = { status, vol, vol_exec, price, cost, fee, type, pair }

        recorder.track("binance", txObj)

    catch err then log err
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