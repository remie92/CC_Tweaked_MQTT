mqtt={}

function mqtt.init(broker_id)
    mqtt.broker=broker_id
    rednet.send(mqtt.broker,"connect","CONNECT")
end

local function send_pings()
    while true do
        rednet.send(mqtt.broker,"Hehe, ping!","PING")
        sleep(10)
    end
end
local message_queue={}

local function receive_pings()
    while true do
        sleep(0)
        print("Waiting for message!")
        local id, message, protocol = rednet.receive()
        table.insert(message_queue, { id, message, protocol })
        print(("Client %d sent %s as %s"):format(id, message, protocol),"received_message")
    end
end

local function process_pings()
      while true do
        sleep(0)
        if #message_queue > 0 then
            local message = table.remove(message_queue, 1)
            local id = message[1]
            local text = message[2]
            local protocol = message[3]
            clients.got_update(id)
            if protocol == "PUBLISHED" then
                if mqtt.run_func then
                    mqtt.run_func(text)
                end
            end
        end
    end
end

function mqtt.pinger()
    parallel.waitForAll(send_pings,receive_pings,process_pings)
end

function mqtt.subscribe(topic)
    rednet.send(mqtt.broker,topic,"SUBSCRIBE")
end

function mqtt.publish(topic,data)
    rednet.send(mqtt.broker,{topic,data},"PUBLISH")
end

function mqtt.set_on_subscribe(func)
    mqtt.run_func=func
end