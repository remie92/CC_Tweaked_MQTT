require("logger")
logger.setMonitor(peripheral.wrap("left"))
logger.setLogAll()
peripheral.find("modem", rednet.open)

function lib_sender(id)
    print("Sending MQTT File to ", id)
    local file = io.open("mqtt.lua", "r")
    rednet.send(id, file:read("a"), "MQTT_LIB_MQTT")
    file:close()
    logger.log("Send mqtt.lua to "..id,"sent_message")
end

message_queue = {}


function rednet_receiver()
    logger.log("Starting Rednet Receiver Thread!","log")
    while true do
        sleep(0)
        print("Waiting for message!")
        local id, message, protocol = rednet.receive()
        table.insert(message_queue, { id, message, protocol })
        logger.log(("Client %d sent %s as %s"):format(id, text, protocol),"received_message")
    end
end

function do_message_queue()
    logger.log("Starting Message Queue Thread!","log")
    while true do
        sleep(0)
        if #message_queue > 0 then
            message = table.remove(message_queue, 1)
            id = message[1]
            text = message[2]
            protocol = message[3]
            logger.log("Processing "..protocol.." from "..id,"processing_message")
            if protocol == "MQTT_LIB" then
                lib_sender(id)
            end
        end
    end
end

function do_log_update()
    logger.log("Starting Log Renderer Thread!","log")
    while true do
        sleep(0.3)
        logger.draw()
    end
end

while true do
    parallel.waitForAll(rednet_receiver, do_message_queue,do_log_update)
    rednet_receiver()
    sleep(1)
end
