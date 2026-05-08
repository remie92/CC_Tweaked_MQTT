require("mqtt")
mqtt.init(0)
sleep(1)
mqtt.subscribe("chestAmount")

function textWriter(data)
    monitor=peripheral.wrap("top")
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.write("Slots used: "..data)
end

mqtt.set_on_subscribe(textWriter)

parallel.waitForAll(mqtt.pinger)