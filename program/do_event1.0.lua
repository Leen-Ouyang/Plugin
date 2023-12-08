do_daily_order = "执行每日事件"
do_weekly_order = "执行每周事件"
Temp = "temp.json" --temp json文件夹读取
Event = "Event.json"
Player = "player.json"
Semester = "Semester.json"
Achievement = "achievement.json"


config = {
    exam_chance = 50, --考试成功概率
    msg = {
        no_energy = "你今天太累了，好好休息一天吧\n",
        no_generate_daily = "你还没生成每日事件呢，先去“生成每日事件”看看自己今天应该做些什么吧！\n",
        no_generate_weekly = "你还没生成每周事件呢，先去“生成每周事件”看看自己这周应该做些什么吧！\n",
        exam_fail = "太惨了，你挂科了，准备补考吧！\n",
        error_string = "发生错误\n"
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

data4 = getSelfData(Achievement);
achievement = data4:get(nil,{})
if(achievement == nil)then
    achievement = {}
end

function init_day(QQ)
    temp[QQ].next_daily.num = nil
    temp[QQ].next_daily.generate_time = nil
    temp[QQ].next_daily.type = nil
end

function init_week(QQ)
    temp[QQ].next_weekly.num = nil
    temp[QQ].next_weekly.generate_time = nil
    temp[QQ].next_weekly.type = nil
end

function save()
    data:set(temp)
    data1:set(event)
    data2:set(player)
    data3:set(semester)
    data4:set(achievement)
end

function hadAchievement(uid,name)
    
    local isInArray = false
    for _, value in ipairs(player[uid]["Achievement"]) do
        if value == name then
            isInArray = true
            break
        end
    end

    return isInArray
end

function judge_achievement(uid)
    local res=""
    for key,value in pairs(achievement) do
        if value["unique"]~=2 and hadAchievement(uid,key)==false then
            local flag=1;
            for key1,value1 in pairs(value["premise"]) do
                if key1=="points" then
                    if value1>player[uid][key1]then
                        flag=0
                    end
                elseif key1=="Bag" then
                    if player[uid][key1][value1] == nil then
                        flag=0;
                    end
                else
                    for key2,value2 in pairs(value1) do

                        if type(value2)=="number" then
                            if player[uid][key1][key2]==nil then
                                player[uid][key1][key2]=0
                            end
                            if value2>player[uid][key1][key2] then
                                flag=0
                            end
                        elseif type(value2)=="string" and player[uid][key1][key2][value2]==nil then
                            flag=0
                        end
                    end 
                end
            end
            if flag==1 then
                res=res..value["description"]..'\n'.."获得成就："..value["name"]..'\n'
                if value["unique"]==1 then
                    value["unique"]=2
                end
                table.insert(player[uid]["Achievement"],key)
                
            end
            
        end
        --先判断有没有这个成就了
    end
    return res
end

local function show(playername, changetype, num)
    local message = ""
    if changetype == "Bag" then
        message = message .. playername.."获得物品:"..num..'\n'
    else
        if num < 0 then
            message = playername .. "的" .. changetype .. "减少了" .. (-num)
        elseif num > 0 then
            message = playername .. "的" .. changetype .. "增加了" .. num
        else
            message = playername .. "的" .. changetype .. "没有变化"
        end
    end
    return message
end


local function successfulchange(QQ,list)
    local s = ""
    for key, value in pairs(list) do
        s = s..show("玩家",key,value).."\n"
        if key == "point" then 
            player[QQ]["points"]=player[QQ]["points"]+value;
        elseif key == "credit" then 
            player[QQ]["Mainline"]["credit"]=player[QQ]["Mainline"]["credit"]+value
        elseif key == "CON" or key == "WIL" or key == "LUC" or key == "INT" then
            player[QQ]["MainAtt"][key]=player[QQ]["MainAtt"][key]+value
        elseif key == "Bag" then
            if player[QQ][key][value] == nil then
                player[QQ][key][value]["count"]=1
            else
                player[QQ][key][value]["count"]=player[QQ][key][value]["count"]+1
            end
        else
            if(player[QQ]["Count"][key]==nil)then 
                player[QQ]["Count"][key]=value
            else
                player[QQ]["Count"][key]=player[QQ]["Count"][key]+value
            end
        end
    end
    return s;
end


local function do_exam(msg)
    local QQ = msg.fromQQ
    math.randomseed(os.time()) -- 使用当前时间作为随机种子
    local randomInt = math.random(0,100);
    local s=""
    if(randomInt>config.exam_chance)then
        return config.msg.exam_fail;
    else
        player[QQ]["Mainline"]["Semester"]=player[QQ]["Mainline"]["Semester"]+1
        player[QQ]["Mainline"]["credit"]=0
        local s = semester[player[QQ]["Mainline"]["Semester"]]["description"].."\n"..semester[player[QQ]["Mainline"]["Semester"]]["fixes"].."\n"
        s=s..judge_achievement(QQ)..'\n'
        
        init_day(QQ)
        init_week(QQ)
        save()
    end
    return s;
end

function do_event(QQ,Type,num,kind)
    local s=""

    if event[Type][num][1]["energy"]<0 and -event[Type][num][1]["energy"]>player[QQ]["DailyAtt"]["energy"] then
        return config.msg.no_energy
     end
 --判断随机事件
     for key, value in pairs(event["Spec"]) do
         if value[1]["pre"]["event"][1] == Type and value[1]["pre"]["event"][2] == num then
             local chance = value[1]["odds"]*100
             --local chance = 100
             math.randomseed(os.time()) -- 使用当前时间作为随机种子
             local randomnum = math.random(1,100)


             if randomnum <= chance then-- 触发随机事件
                math.randomseed(os.time())
                local idx = math.random(1,#value)
                 s = s..value[idx]["description"].."\n"
                 
                 local odd = value[idx]["diff"]
                 local random = math.random(0,20)
                 local judge = value[idx]["judge"]
                 if(player[QQ]["MainAtt"][judge]-10+random > odd)then
                     s = s..value[idx]["success"].."\n"
                     s = s..successfulchange(QQ,value[idx]["change"])..'\n'
                     if player[QQ]["Event"]["Spec"][key] == nil then 
                        player[QQ]["Event"]["Spec"][key]=1
                     end
                 else 
                     s = s..value[idx]["failure"].."\n"
                 end
                 player[QQ]["DailyAtt"]["energy"]=player[QQ]["DailyAtt"]["energy"]+value[idx]["energy"]
                 s = s..show("玩家","energy",value[idx]["energy"])..'\n';
                 player[QQ]["DailyAtt"]["mood"]=player[QQ]["DailyAtt"]["mood"]+value[idx]["mood"]
                 s = s..show("玩家","mood",value[idx]["mood"])..'\n';    
                 s=s..judge_achievement(QQ)..'\n'

                 if(kind=="daily")then
                    table.insert(temp[QQ]["daily_done"],temp[QQ]["next_daily"].num)
                    init_day(QQ)
                 else
                    table.insert(temp[QQ]["weekly_done"],temp[QQ]["next_weekly"].num)
                    init_week(QQ)
                end
                 
                 return s
             end
             break
         end
     end
 
 
     --判断事件是否执行成功
     local cnt = #event[Type][num];
     math.randomseed(os.time()) -- 使用当前时间作为随机种子
     local idx = math.random(1,cnt)
 
     local odd = event[Type][num][idx]["diff"];
 
     local random = math.random(0,20);
     local judge = event[Type][num][idx]["judge"];
     if(player[QQ]["MainAtt"][judge]-10+random > odd)then
         s = s..event[Type][num][idx]["success"].."\n"
         s = s..successfulchange(QQ,event[Type][num][idx]["change"])..'\n'
         if(player[QQ]["Event"][Type][num]==nil)then
            player[QQ]["Event"][Type][num]=1
         end
     else
         s = s..event[Type][num][idx]["failure"].."\n"
     end
     player[QQ]["DailyAtt"]["energy"]=player[QQ]["DailyAtt"]["energy"]+event[Type][num][idx]["energy"]
     s = s..show("玩家","energy",event[Type][num][idx]["energy"])..'\n';
     player[QQ]["DailyAtt"]["mood"]=player[QQ]["DailyAtt"]["mood"]+event[Type][num][idx]["mood"]
     s = s..show("玩家","mood",event[Type][num][idx]["mood"])..'\n';    
     if(kind=="daily")then
        table.insert(temp[QQ]["daily_done"],temp[QQ]["next_daily"].num)
        init_day(QQ)
     else
        table.insert(temp[QQ]["weekly_done"],temp[QQ]["next_weekly"].num)
        init_week(QQ)
    end
     s=s..judge_achievement(QQ)..'\n'

    return s;

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

    if(temp[QQ].next_daily.type == "exam")then
        return do_exam(msg)
    end

    local num = temp[QQ]["next_daily"]["num"]
    local Type = temp[QQ]["next_daily"]["type"]
    s = s..do_event(QQ,Type,num,"daily");
    save()
    return s;
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

    if(temp[QQ].next_weekly.type == "exam")then
        return do_exam(msg)
    end

    local num = temp[QQ]["next_weekly"]["num"]
    local Type = temp[QQ]["next_weekly"]["type"]
    s = s..do_event(QQ,Type,num,"weekly");
    save()
    return s;
end
