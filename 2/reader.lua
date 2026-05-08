require("mqtt")
mqtt.init(0)
mqtt.subscribe("chestAmount")

parallel.waitForAll(mqtt.pinger)