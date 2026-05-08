peripheral.find("modem", rednet.open)

function receive()
    receivedCode = false
    while receivedCode == false do
        sleep(0)
        print("Waiting for message!")
        local id, message, protocol =rednet.receive(10)
        print("Received",received)
        if id~=nil then
            if protocol == "MQTT_LIB_MQTT" then
                receivedCode = true
                local f = fs.open("mqtt.lua", "w")
                if f then
                    f.write(message)
                    f.close()
                    print("Wrote message to mqtt.lua")
                else
                    print("Error: could not open mqtt.lua for writing")
                end
            end
        else
            print("GETTING MQTT FAILED")
            sleep(math.random(2,10))
            parallel.waitForAll(receive, send_file_request)
        end
    end
end

function send_file_request()
    sleep(1)
    rednet.send(0, "data", "MQTT_LIB")
    print("Sent LIB request!")
end

parallel.waitForAll(receive, send_file_request)

shell.run("reader")