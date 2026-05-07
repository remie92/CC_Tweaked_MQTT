peripheral.find("modem", rednet.open)

function lib_sender(id)
    print("Sending MQTT File to ",id)
    local file = io.open("mqtt.lua", "r")
    rednet.send(id,file:read("a"),"MQTT_LIB_MQTT")
    file:close()
end

function rednet_receiver()
    while true do
        sleep(0)
        print("Waiting for message!")
        local id, message, protocol = rednet.receive()
        print(("Computer %d sent message %s with protocol %s"):format(id, message, protocol))
        if protocol=="MQTT_LIB" then
            lib_sender(id)
        end
    end
end


while true do
    rednet_receiver()
    sleep(1)
end