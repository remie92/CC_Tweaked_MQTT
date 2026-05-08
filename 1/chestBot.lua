
require("mqtt")
mqtt.init(0)
function chestCounter()
    while true do
        sleep(6)
        chest=peripheral.wrap("right")
        mqtt.publish("chestAmount",#chest.list())
    end
end
parallel.waitForAll(mqtt.pinger,chestCounter)