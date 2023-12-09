Temp = "temp.json" --temp json文件夹读取
Event = "Event.json"
Player = "player.json"
Semester = "Semester.json"
Achievement = "achievement.json"
Shop = "shop.json"

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

data5 = getSelfData(Shop);
shop = data5:get(nil,{})
if(shop == nil)then
    shop = {}
end


-- 方法 2: 使用 table.remove 移除所有元素
for key,value in pairs(temp) do
    while #value["weekly_done"] > 0 do
        table.remove(value["weekly_done"])
    end

    while #value["daily_done"] > 0 do
        table.remove(value["daily_done"])
    end

    value.next_daily.num = nil
    value.next_daily.generate_time = nil
    value.next_daily.type = nil
    value.next_weekly.num = nil
    value.next_weekly.generate_time = nil
    value.next_weekly.type = nil
end

for key,value in pairs(player) do
    value["DailyAtt"]["mood"]=value["DailyAtt"]["mood_limit"]
    value["DailyAtt"]["energy"]=value["DailyAtt"]["energy_limit"]
end

for key,value in pairs(shop) do
    if(key="Common") then
        for k,v in pairs(value) do
            if(v["max_count"]~=nil) then
                v["count"]=v["max_count"]
            end
        end
    end
end

data:set(temp)
data1:set(event)
data2:set(player)
data3:set(semester)
data4:set(achievement)
data5:set(shop)
