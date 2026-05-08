
require("mqtt")
mqtt.init(0)
parallel.waitForAll(mqtt.pinger)