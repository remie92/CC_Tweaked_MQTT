clients = {}


function clients.setMonitor(monitor)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.green)
    clients.monitor = monitor
    clients.monitor.setTextScale(0.5)
end


function clients.got_update(id)
    for i, v in ipairs(clients.connected) do
        if v.id==id then
            v.time=os.clock()
        end
    end
end

function clients.client_ticker()
    while true do
        sleep(0.4)
        for i = #clients.connected, 1, -1 do
            if os.clock()-clients.connected[i].time > 90 then
                logger.log(clients.connected[i].id .. " disconnected!", "connection")
                table.remove(clients.connected, i)
                
            end
        end

        clients.monitor.clear()

        for i, v in ipairs(clients.connected) do
            local id = v.id
            local time = v.time
            local topics = v.topics
            clients.monitor.setCursorPos(1, i)
            clients.monitor.setTextColor(colors.green)
            clients.monitor.write(string.format("[%s] Topics: %d. ", id, #topics))
            local last_seen=math.floor(os.clock() - time)
            if last_seen>40 then
                clients.monitor.setTextColor(colors.yellow)
            end
            if last_seen>60 then
                clients.monitor.setTextColor(colors.orange)
            end
            if last_seen>80 then
                clients.monitor.setTextColor(colors.red)
            end
            
            clients.monitor.write("Last seen: "..last_seen)
            clients.monitor.setTextColor(colors.green)
        end
    end
end

clients.connected = {}
function clients.addClient(id)
    for i, v in ipairs(clients.connected) do
        if v.id == id then
            logger.log(id .. " was already connected!", "warning")
            return
        end
    end
    table.insert(clients.connected, { ["id"] = id, ["time"] = os.clock(), ["topics"] = {} })
    logger.log(id .. " established connection!", "connection")
end

function clients.setLogger(logger)
    clients.logger = logger
end
