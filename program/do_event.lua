do_daily_order = "执行每日事件"
do_weekly_order = "执行每周事件"
Temp = "temp.json" --temp json文件夹读取
Event = "Event.json"
Player = "player.json"
Semester = "Semester.json"


config = {
    exam_chance = 50, --考试成功概率
    msg = {
        no_energy = "你今天太累了，好好休息一天吧\n",
        no_generate_daily = "你还没生成每日事件呢，先去“生成每日事件”看看自己今天应该做些什么吧！\n",
        no_generate_weekly = "你还没生成每周事件呢，先去“生成每周事件”看看自己这周应该做些什么吧！\n",
        exam_fail = "太惨了，你挂科了，准备补考吧！\n",
    }
}
msg_order = {}
msg_order[do_daily_order] = "do_daily"
msg_order[do_weekly_order] = "do_weekly"
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

data3 = getSelfData(Semester);
semester = data3:get(nil,{})
if(semester == nil)then
    semester = {}
end

local function show(playername, changetype, num)
    if type(playername) == "string" and type(changetype) == "string" and type(num) == "number" then
        local message = ""
        if num < 0 then
            message = playername .. "的" .. changetype .. "减少了" .. (-num)
        elseif num > 0 then
            message = playername .. "的" .. changetype .. "增加了" .. num
        else
            message = playername .. "的" .. changetype .. "没有变化"
        end
        return message;
    else
        return config.msg.error_string;
    end
end


local function do_exam(msg)
    local QQ = msg.fromQQ
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local randomInt = math.random(0,100);

    if(randomInt>exam_chance)then
        return config.msg.exam_fail;
    else
        player[QQ]["Mainline"]["Semester"]=player[QQ]["Mainline"]["Semester"]+1
        player[QQ]["Mainline"]["credit"]=0
        local s = semester[player[QQ]["Mainline"]["Semester"]]["description"].."\n"..semester[player[QQ]["Mainline"]["Semester"]]["fixes"].."\n"
        temp[QQ].next_daily.num = nil
        temp[QQ].next_daily.generate_time = nil
        temp[QQ].next_daily.type = nil
        temp[QQ].next_weekly.num = nil
        temp[QQ].next_weekly.generate_time = nil
        temp[QQ].next_weekly.type = nil
        data:set(temp)
        data1:set(event)
        data2:set(player)
        data3:set(semester)
        return s;
    end
end

function do_daily(msg)

    local QQ = msg.fromQQ
    local s = ""
    if temp[QQ].next_daily.type == "nil" then
        temp[QQ].next_daily.type = nil
    end
    if(temp[QQ].next_daily.type == nil)then
        return config.msg.no_generate_daily
    end

    if(temp[QQ].next_daily.type == exam)then
        return do_exam(msg)
    end

    local num = temp[QQ]["next_daily"]["num"]
    local Type = temp[QQ]["next_daily"]["type"]
    --判断事件是否执行成功
    local cnt = #event[Type][num];
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local idx = math.random(1,cnt)

    local odd = event[Type][num][idx]["diff"];

    local random = math.random(0,20);
    local judge = event[Type][num][idx]["judge"];
    if(player[QQ]["MainAtt"][judge]-10+random > odd)then
        s = s..event[Type][num][idx]["success"].."\n"
        for key, value in pairs(event[Type][num][idx]["change"]) do
            s = s..show("玩家",key,value).."\n"
            if key == "point" then 
                player[QQ]["points"]=player[QQ]["points"]+value;
            elseif key == "credit" then 
                player[QQ]["Mainline"]["credit"]=player[QQ]["Mainline"]["credit"]+value
            elseif key == "CON" or key == "WIL" or key == "LUC" or key == "INT" then
                player[QQ]["MainAtt"][key]=player[QQ]["MainAtt"][key]+value
            else
                player[QQ]["Count"][key]=player[QQ]["Count"][key]+value
            end
        end
    else
        s = s..event[Type][num][idx]["failure"].."\n"
    end
    player[QQ]["DailyAtt"]["energy"]=player[QQ]["DailyAtt"]["energy"]+event[Type][num][idx]["energy"]
    s = s..show("玩家","energy",event[Type][num][idx]["energy"])..'\n';
    player[QQ]["DailyAtt"]["mood"]=player[QQ]["DailyAtt"]["mood"]+event[Type][num][idx]["mood"]
    s = s..show("玩家","mood",event[Type][num][idx]["mood"])..'\n';    
    table.insert(temp[QQ]["daily_done"],temp[QQ]["next_daily"].num)
    temp[QQ].next_daily.num = nil
    temp[QQ].next_daily.generate_time = nil
    temp[QQ].next_daily.type = nil
    data:set(temp)
    data1:set(event)
    data2:set(player)
    data3:set(semester)
    return s
end


function do_weekly(msg)
    local QQ = msg.fromQQ
    local s = ""
    if temp[QQ].next_weekly.type == "nil" then
        temp[QQ].next_weekly.type = nil
    end
    if(temp[QQ].next_weekly.type == nil)then
        return config.msg.no_generate_weekly
    end

    if(temp[QQ].next_weekly.type == exam)then
        return do_exam(msg)
    end

    local num = temp[QQ]["next_weekly"]["num"]
    local Type = temp[QQ]["next_weekly"]["type"]
    --判断事件是否执行成功
    local cnt = #event[Type][num];
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local idx = math.random(1,cnt)

    local odd = event[Type][num][idx]["diff"];

    local random = math.random(0,20);
    local judge = event[Type][num][idx]["judge"];
    if(player[QQ]["MainAtt"][judge]-10+random > odd)then
        s = s..event[Type][num][idx]["success"].."\n"
        for key, value in pairs(event[Type][num][idx]["change"]) do
            s = s..show("玩家",key,value).."\n"
            if key == "point" then 
                player[QQ]["points"]=player[QQ]["points"]+value;
            elseif key == "credit" then 
                player[QQ]["Mainline"]["credit"]=player[QQ]["Mainline"]["credit"]+value
            elseif key == "CON" or key == "WIL" or key == "LUC" or key == "INT" then
                player[QQ]["MainAtt"][key]=player[QQ]["MainAtt"][key]+value
            else
                player[QQ]["Count"][key]=player[QQ]["Count"][key]+value
            end
        end
    else
        s = s..event[Type][num][idx]["failure"].."\n"
    end
    player[QQ]["DailyAtt"]["energy"]=player[QQ]["DailyAtt"]["energy"]+event[Type][num][idx]["energy"]
    s = s..show("玩家","energy",event[Type][num][idx]["energy"])..'\n';
    player[QQ]["DailyAtt"]["mood"]=player[QQ]["DailyAtt"]["mood"]+event[Type][num][idx]["mood"]
    s = s..show("玩家","mood",event[Type][num][idx]["mood"])..'\n';    
    table.insert(temp[QQ]["weekly_done"],temp[QQ]["next_weekly"].num)
    temp[QQ].next_weekly.num = nil
    temp[QQ].next_weekly.generate_time = nil
    temp[QQ].next_weekly.type = nil
    data:set(temp)
    data1:set(event)
    data2:set(player)
    data3:set(semester)
    return s
end
