require("mqtt")
mqtt.init(0)
sleep(1)
mqtt.subscribe("chestAmount")

parallel.waitForAll(mqtt.pinger)