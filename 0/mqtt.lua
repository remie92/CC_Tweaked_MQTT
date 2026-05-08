mqtt={}

function mqtt.init(broker_id)
    mqtt.broker=broker_id
    rednet.send(mqtt.broker,"connect","CONNECT")
end


function mqtt.pinger()
    while true do
        rednet.send(mqtt.broker,"Hehe, ping!","PING")
        sleep(10)
    end
end

function mqtt.subscribe(topic)
    rednet.send(mqtt.broker,topic,"SUBSCRIBE")
end