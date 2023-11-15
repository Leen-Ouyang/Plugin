--关键词
search_event_order = "事件查看"
execute_day_order = "执行每周事件"
execute_week_order = "执行每日事件"

--插件配置
Event = "Event" --事件json文件夹读取
Player = "player" --玩家json文件夹读取
Temp = "temp" --temp json文件夹读取
json = require("json")

config = {

    msg = {
        --回复词

    }
}

-------------分割线--------------
msg_order[] = {}
msg_order[search_event_order] = "search_event"
msg_order[execute_day_order] = "execute_day"
msg_order[execute_week_order] = "execute_week"

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
data3 = getSelfData(Temp)

temp = data3:get(nil,{})
if(temp == nil)then
    temp = {}
end



-----判断是否在同一天----
function isSameDay(time1, time2)
    -- 使用 os.date 将时间戳转换为表格式
    local t1 = os.date("*t", time1)
    local t2 = os.date("*t", time2)

    -- 比较年、月、日是否相同
    return t1.year == t2.year and t1.month == t2.month and t1.day == t2.day
end






----------生成下一个每日事件------------
local function generate_day(msg)
    --如果下一个每日事件已经过期了或者已经被执行，清空temp里对应uid事件，重新生成
    local QQ = msg.fromQQ
    local time = os.time()
    if(isSameDay(time,temp[QQ].next_daily.generate_time) == false)then
        table.clear(temp[QQ].daily_done)
        temp[QQ].next_daily.generate_time = nil
        temp[QQ].next_daily.num = nil
        temp[QQ].next_daily.type = nil;
    else(temp[QQ].next_daily.generate_time=="nil" or isSameDay(time,temp[QQ].next_daily.generate_time))then
    
        if(temp[QQ].next_daily.generate_time!="nil") then--把上一次的存在里面
            table.insert(temp[QQ].daily_done,temp[QQ].next_daily.num)

        end
        
    end
    
    if()then--先判断学分够不够考试事件，够就进入考试事件
        
    else then--如果分数还达不到考试阶段
    
        
        local flag = 0
        while flag do
            math.randomseed(os.time()) -- 使用当前时间作为随机种子
            local randomInt = math.random(100, 199)
            -- 将整数转换为3位字符串
            local formattedString = string.format("NO%03d", randomInt)
            if(player[QQ].Semeste>event["Daily"][formattedString].)then
                flag=1
            end
        end
        temp[QQ].next_daily.generate_time = time
        temp[QQ].next_daily.num = formattedString
        temp[QQ].next_daily.type = "Daily";
    end

end






----------生成下一个每周事件------------
local function generate_week(msg)
    --如果下一个每周事件已经过期了或者已经被执行，清空temp里对应uid事件，重新生成
    local time = os.time()
    local QQ = msg.fromQQ
    if(isSameDay(time,temp[QQ].next_weekly.generate_time) == false)then
        table.clear(temp[QQ].weekly_done)
        temp[QQ].next_weekly.generate_time = nil
        temp[QQ].next_weekly.num = nil
        temp[QQ].next_weekly.type = nil;
    else(temp[QQ].next_weekly.generate_time=="nil" or isSameDay(time,temp[QQ].next_weekly.generate_time))then
        if(temp[QQ].next_weekly.generate_time!="nil")then--把上一次的存在里
            table.insert(temp[QQ].weekly_done,temp[QQ].next_weekly.num)
        end
    end

    if()then--先判断学分够不够考试事件，够就进入考试事件
        
            
    else then--如果分数还达不到考试阶段
    
        
        local flag = 0
        while flag do
            math.randomseed(os.time()) -- 使用当前时间作为随机种子
            local randomInt = math.random(100, 199)
            -- 将整数转换为3位字符串
            local formattedString = string.format("NO%03d", randomInt)
            if(player[QQ].Semeste>event["Weekly"][formattedString].)then
                flag=1
            end
        end
        
        temp[QQ].next_weekly.generate_time = time
        temp[QQ].next_weekly.num = formattedString
        temp[QQ].next_weekly.type = "Weekly";
    end

end



-----------查找事件功能-----------
function search_event(msg)
    local QQ = msg.fromQQ
    if(temp[QQ].next_daily.generate_time==nil)generate_day(msg);
    if(temp[QQ].next_weekly.generate_time==nil)generate_week(msg);

    s = "今日已完成事件：\n"
    --查看已完成事件
    s = s.."  每日事件：\n"
    for i = 0, #temp[QQ].daily_done do 
        s = s.."    "..event[Daily][temp[QQ].daily_done[i]].."\n"
    end
    s = s.."  每周事件：\n"
    for i = 0, #temp[QQ].weekly_done do 
        s = s.."    "..event[Weekly][temp[QQ].daily_done[i]].."\n"
    end

    if(temp[QQ].next_daily.type=="Exam")then 
        temp[QQ].next_weekly.generate_time = temp[QQ].next_daily.generate_time
        temp[QQ].next_weekly.num = temp[QQ].next_daily.num
        temp[QQ].next_weekly.type = temp[QQ].next_daily.type
    end
    if(temp[QQ].next_weekly.type=="Exam")then 
        temp[QQ].next_daily.generate_time = temp[QQ].next_weekly.generate_time
        temp[QQ].next_daily.num = temp[QQ].next_weekly.num
        temp[QQ].next_daily.type = temp[QQ].next_weekly.type
    end


    --查看下一项每日事件，以及相关具体信息
    if(temp[QQ].next_daily.type=="Daily")then
        s = s.."  下一项每日事件："..event[Daily][temp[QQ].next_daily.num].."\n"
    end
    --查看下一项每周事件，以及相关具体信息
    if(temp[QQ].next_weekly.type=="Weekly")then
        s = s.."  下一项每周事件："..event[Weekly][temp[QQ].next_weekly.num].."\n"
    end
    --考试的话
    if(temp[QQ].next_daily.type==1)then 
        s = s.."  该准备考试了！".."\n"
    end


    data1:set(event)
    data2:set(player)
    data3:set(temp)

    return s
end




---------执行每日事件功能---------
function execute_day(msg)
    --判断是否触发随机事件
    local QQ = msg.fromQQ
    local chance = player[QQ]["MainAtt"]["LUC"]-10;
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local randomInt = math.random(0,100);
    s = ""
    if(randomInt>chance)then --正常执行
        s = s.."触发随机事件\n"
        local flag = 0
        while flag do
            math.randomseed(os.time()) -- 使用当前时间作为随机种子
            local randomInt = math.random(200,399)
            -- 将整数转换为3位字符串
            local formattedString = string.format("NO%03d", randomInt)
            if(player[QQ].Semeste>event[Daily][formattedString].)then
                flag=1
            end
        end
        temp[QQ].next_daily.generate_time = time
        temp[QQ].next_daily.num = formattedString
        temp[QQ].next_daily.type = "Spec";
    end

    local num = temp[QQ][next_daily][num]
    local type = temp[QQ][next_daily]["type"]
    --判断事件是否执行成功
    local cnt = #event[type][num];
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local randomInt = math.random(1,cnt)

    local odd = event[type][num][randomInt]["diff"];

    local random = math.random(0,20);
    local judge = event[type][num][randomInt]["judge"];
    if(player[QQ]["MainAtt"][judge]-10+randowm > odd)then
        s = s..event[type][num][randomInt]["success"].."\n"
        player[QQ]["MainAtt"]["INT"]=player[QQ]["MainAtt"]["INT"]+event[type][num][randomInt]["change"]["INT"]
        player[QQ]["MainAtt"]["CON"]=player[QQ]["MainAtt"]["CON"]+event[type][num][randomInt]["change"]["CON"]
        player[QQ]["MainAtt"]["WIL"]=player[QQ]["MainAtt"]["WIL"]+event[type][num][randomInt]["change"]["WIL"]
        player[QQ]["MainAtt"]["LUC"]=player[QQ]["MainAtt"]["LUC"]+event[type][num][randomInt]["change"]["LUC"]
        player[QQ]["MainAtt"]["SUM"]=player[QQ]["MainAtt"]["INT"]+ player[QQ]["MainAtt"]["CON"]+player[QQ]["MainAtt"]["WIL"]+player[QQ]["MainAtt"]["SUM"]
        s = s.."以下玩家属性发生变化：\n"
        s = s.."INT获得"..event[type][num][randomInt]["change"]["INT"].."  玩家目前INT为："..player[QQ]["MainAtt"]["INT"].."\n"
        s = s.."CON获得"..event[type][num][randomInt]["change"]["CON"].."  玩家目前CON为："..player[QQ]["MainAtt"]["CON"].."\n"
        s = s.."WIL获得"..event[type][num][randomInt]["change"]["WIL"].."  玩家目前WIL为："..player[QQ]["MainAtt"]["WIL"].."\n"
        s = s.."LUC获得"..event[type][num][randomInt]["change"]["LUC"].."  玩家目前LUC为："..player[QQ]["MainAtt"]["LUC"].."\n"

    else then
        s = s..event[type][num][randomInt]["failure"].."\n"
        s = s.."以下玩家属性发生变化：\n"
    end



    --更新参数，维护数据库
    player[QQ]["DailyAtt"]["energy"]=player[QQ]["DailyAtt"]["energy"]+event[type][num][randomInt]["energy"]
    s = s.."energy获得"..event[type][num][randomInt]["energy"].."  玩家目前energy为："..player[QQ]["DailyAtt"]["energy"].."\n"
    player[QQ]["DailyAtt"]["mood"]=player[QQ]["DailyAtt"]["mood"]+event[type][num][randomInt]["mood"]
    s = s.."mood获得"..event[type][num][randomInt]["mood"].."  玩家目前mood为："..player[QQ]["DailyAtt"]["mood"].."\n"

    --生成下一个事件
    generate_day(msg)
    data1:set(event)
    data2:set(player)
    data3:set(temp)
    return s
    
end


---------执行每周事件功能---------
function execute_week(msg)
    --判断是否触发随机事件
    local QQ = msg.fromQQ
    local chance = player[QQ]["MainAtt"]["LUC"]-10;
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local randomInt = math.random(0,100);
    s = ""
    if(randomInt>chance)then --正常执行
        s = s.."触发随机事件\n"
        local flag = 0
        while flag do
            math.randomseed(os.time()) -- 使用当前时间作为随机种子
            local randomInt = math.random(200,399)
            -- 将整数转换为3位字符串
            local formattedString = string.format("NO%03d", randomInt)
            if(player[QQ].Semeste>event[Daily][formattedString].)then
                flag=1
            end
        end
        temp[QQ].next_weekly.generate_time = time
        temp[QQ].next_weekly.num = formattedString
        temp[QQ].next_weekly.type = "Spec";
    end

    local num = temp[QQ]["next_weekly"][num]
    local type = temp[QQ]["next_weekly"]["type"]
    --判断事件是否执行成功
    local cnt = #event[type][num];
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local randomInt = math.random(1,cnt)

    local odd = event[type][num][randomInt]["diff"];

    local random = math.random(0,20);
    local judge = event[type][num][randomInt]["judge"];
    if(player[QQ]["MainAtt"][judge]-10+randowm > odd)then
        s = s..event[type][num][randomInt]["success"].."\n"
        player[QQ]["MainAtt"]["INT"]=player[QQ]["MainAtt"]["INT"]+event[type][num][randomInt]["change"]["INT"]
        player[QQ]["MainAtt"]["CON"]=player[QQ]["MainAtt"]["CON"]+event[type][num][randomInt]["change"]["CON"]
        player[QQ]["MainAtt"]["WIL"]=player[QQ]["MainAtt"]["WIL"]+event[type][num][randomInt]["change"]["WIL"]
        player[QQ]["MainAtt"]["LUC"]=player[QQ]["MainAtt"]["LUC"]+event[type][num][randomInt]["change"]["LUC"]
        player[QQ]["MainAtt"]["SUM"]=player[QQ]["MainAtt"]["INT"]+ player[QQ]["MainAtt"]["CON"]+player[QQ]["MainAtt"]["WIL"]+player[QQ]["MainAtt"]["SUM"]
        s = s.."以下玩家属性发生变化：\n"
        s = s.."INT获得"..event[type][num][randomInt]["change"]["INT"].."  玩家目前INT为："..player[QQ]["MainAtt"]["INT"].."\n"
        s = s.."CON获得"..event[type][num][randomInt]["change"]["CON"].."  玩家目前CON为："..player[QQ]["MainAtt"]["CON"].."\n"
        s = s.."WIL获得"..event[type][num][randomInt]["change"]["WIL"].."  玩家目前WIL为："..player[QQ]["MainAtt"]["WIL"].."\n"
        s = s.."LUC获得"..event[type][num][randomInt]["change"]["LUC"].."  玩家目前LUC为："..player[QQ]["MainAtt"]["LUC"].."\n"

    else then
        s = s..event[type][num][randomInt]["failure"].."\n"
        s = s.."以下玩家属性发生变化：\n"
    end



    --更新参数，维护数据库
    player[QQ]["DailyAtt"]["energy"]=player[QQ]["DailyAtt"]["energy"]+event[type][num][randomInt]["energy"]
    s = s.."energy获得"..event[type][num][randomInt]["energy"].."  玩家目前energy为："..player[QQ]["DailyAtt"]["energy"].."\n"
    player[QQ]["DailyAtt"]["mood"]=player[QQ]["DailyAtt"]["mood"]+event[type][num][randomInt]["mood"]
    s = s.."mood获得"..event[type][num][randomInt]["mood"].."  玩家目前mood为："..player[QQ]["DailyAtt"]["mood"].."\n"

    --生成下一个事件
    generate_week(msg)
    data1:set(event)
    data2:set(player)
    data3:set(temp)
    return s;

end
