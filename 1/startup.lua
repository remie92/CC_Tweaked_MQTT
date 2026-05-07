peripheral.find("modem", rednet.open)
rednet.send(0,"data","MQTT_LIB")
print("Sent LIB request!")