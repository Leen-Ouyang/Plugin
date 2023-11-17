generate_daily_order = "生成每日事件"
generate_weekly_order = "生成每周事件"
Temp = "temp.json" --temp json文件夹读取
Event = "Event.json"
Player = "player.json"
config = {
    min_credit = 15,
    msg = {
        
        already_generate_daily = "你已经生成了每日事件，做完再说！\n",
        already_generate_weekly = "你已经生成了每周事件，做完再说！\n",
    }
}
msg_order = {}
msg_order[generate_daily_order] = "generate_daily"
msg_order[generate_weekly_order] = "generate_weekly"
data = getSelfData(Temp)
temp = data:get(nil,{})
if(temp == nil)then
    temp = {}
end

data1 = getSelfData(Event)
event = data1:get(nil,{})
if(event == nil)then
    event = {}
end

data2 = getSelfData(Player)
player = data2:get(nil,{})
if(player == nil)then
    player = {}
end

function generate_daily(msg)

    local QQ = msg.fromQQ
    local s = ""
    if temp[QQ].next_daily.generate_time == "nil" then
        temp[QQ].next_daily.generate_time = nil
    end
    if temp[QQ]["next_daily"]["generate_time"] ~= nil then
       return config.msg.already_generate_daily
    end
    
    if player[QQ]["Mainline"]["credit"]>config.min_credit then
        s = s.."马上就要学期末了请好好准备期末考试\n"
        temp[QQ].next_daily.type = "exam"
        temp[QQ].next_weekly.type = "exam"
        return s
    end
    local flag = 0
    local finish = ""
    while flag~=1 do
        math.randomseed(os.time()) -- 使用当前时间作为随机种子
        local randomInt = math.random(0, 6)
        -- 将整数转换为3位字符串
        local formattedString = string.format("NO%03d", randomInt)
        if(event["Daily"][formattedString][1]["limit"]=="null")then
            flag=1
            finish = formattedString
        else 
            local lastChar = string.sub(event["Daily"][formattedString][1]["limit"], -1)
            local lastCharAsInt = tonumber(lastChar)
            if(lastCharAsInt<=player[QQ]["Mainline"]["Semester"])then
                flag=1
                finish = formattedString
            end
        end
    end
   -- event["Daily"][finish][1]["title"]
    s = s.."已经生成名为"..event["Daily"][finish][1]["title"].."的事件\n"
    temp[QQ].next_daily.generate_time = os.time()
    temp[QQ].next_daily.num = finish
    temp[QQ].next_daily.type = "Daily";
    data:set(temp)
    data1:set(event)
    data2:set(player)
    return s
end


function generate_weekly(msg)

    local QQ = msg.fromQQ
    local s = ""
    if temp[QQ].next_weekly.generate_time == "nil" then
        temp[QQ].next_weekly.generate_time = nil
    end
    if temp[QQ]["next_weekly"]["generate_time"] ~= nil then
      return config.msg.already_generate_weekly
    end

    if player[QQ]["Mainline"]["credit"]>config.min_credit then
        s = s.."马上就要学期末了请好好准备期末考试\n"
        temp[QQ].next_daily.type = "exam"
        temp[QQ].next_weekly.type = "exam"
        return s
    end

    
    local flag = 0
    local finish = ""
    while flag~=1 do
        math.randomseed(os.time()) -- 使用当前时间作为随机种子
        local randomInt = math.random(0, 6)
        -- 将整数转换为3位字符串
        local formattedString = string.format("NO1%02d", randomInt)
        if(event["Weekly"][formattedString][1]["limit"]=="null")then
            flag=1
            finish = formattedString
        else 
            local lastChar = string.sub(event["Weekly"][formattedString][1]["limit"], -1)
            local lastCharAsInt = tonumber(lastChar)
            if(lastCharAsInt<=player[QQ]["Mainline"]["Semester"])then
                flag=1
                finish = formattedString
            end
        end
    end
   -- event["Daily"][finish][1]["title"]
    s = s.."已经生成名为"..event["Weekly"][finish][1]["title"].."的事件\n"
    temp[QQ].next_weekly.generate_time = os.time()
    temp[QQ].next_weekly.num = finish
    temp[QQ].next_weekly.type = "Weekly";
    data:set(temp)
    data1:set(event)
    data2:set(player)
    return s
end
