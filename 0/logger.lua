logger={}

logger.logTypes={
    ["log_settings_changed"]=-1,
    ["fatal"]=0,
    ["error"]=1,
    ["warning"]=2,
    ["debug"]=3,
    ["log"]=4,
    ["received_message"]=5,
    ["sent_message"]=6,
    ["processing_message"]=7,
}


logger.typeToText={
    [-1]="LOG",
    [0]="FATAL",
    [1]="ERR",
    [2]="WARN",
    [3]="DEBUG",
    [4]="INFO",
    [5]="RX",
    [6]="TX",
    [7]="RUN",
}


logger.logData={}
function logger.setMonitor(monitor)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.clear()
    monitor.setTextScale(0.5)
    logger.monitor=monitor
end

function logger.setLogFilter(filter)
    logger.level=filter
    logger.log("New Filter: "..textutils.serialize(filter),-1)
end
function logger.setLogAll()
    local list={}
    for _,v in pairs(logger.logTypes) do
        table.insert(list,v)
    end
    logger.setLogFilter(list)
    
end


local function secondToString(seconds)
    local minutes=math.floor(seconds/60)
    seconds=seconds%60
    local hours=math.floor(minutes/60)
    minutes=minutes%60
    if hours > 0 then
        return string.format("[%d:%02d:%05.2f]", hours, minutes, seconds)
    end
    if minutes>0 then
        return string.format("[%02d:%05.2f]",minutes,seconds)
    end
    return string.format("[%05.2f]",seconds)
end


function logger.log(text,logType)
    if type(logType) == "string" then
        logType = logger.logTypes[logType]
    end
    table.insert(logger.logData,{text,logType,os.clock()})
end



function logger.draw()
    logger.monitor.clear()
    logger.monitor.setCursorPos(1,1)
    if #logger.logData>0 then
        local width,height=logger.monitor.getSize()
        local startIndex=math.max(1,#logger.logData-height+2)
        local displayLogs={}
        for i=startIndex,#logger.logData do
            table.insert(displayLogs, logger.logData[i])
        end
        --local output=table.concat(displayLogs,"\n")
        local index=1
        for _,v in ipairs(displayLogs) do
            local text=v[1]
            local type=v[2]
            local time=v[3]
            logger.monitor.setCursorPos(1,index)
            logger.monitor.write(secondToString(time)..": {"..logger.typeToText[type].."} "..text)
            index=index+1
        end
    end
end