--关键词
search_event_order = "事件查看"
execute_day_order = "执行每周事件"
execute_week_order = "执行每日事件"

--插件配置
Event = "" --事件json文件夹读取
Player = "" --玩家json文件夹读取
Temp = "" --temp json文件夹读取
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

event = getSelfData(Event)
player = getSelfData(Player)
temp = getSelfData(Temp)



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
    local time = os.time()
    if(isSameDay(time,temp[msg.uid].next_daily.generate_time) == false)then
        table.clear(temp[msg.uid].daily_done)
        temp[msg.uid].next_daily.generate_time = nil
        temp[msg.uid].next_daily.num = nil
        temp[msg.uid].next_daily.is_exam = 0;
    else(temp[msg.uid].next_daily.generate_time=="nil" or isSameDay(time,temp[msg.uid].next_daily.generate_time))then
    
        if(temp[msg.uid].next_daily.generate_time!="nil") then--把上一次的存在里面
            table.insert(temp[msg.uid].daily_done,temp[msg.uid].next_daily.num)

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
            if(player[msg.uid].Semeste>event[Daily][formattedString].)then
                flag=1
            end
        end
        temp[msg.uid].next_daily.generate_time = time
        temp[msg.uid].next_daily.num = formattedString
        temp[msg.uid].next_daily.is_exam = 0;
    end

end






----------生成下一个每周事件------------
local function generate_week(msg)
    --如果下一个每周事件已经过期了或者已经被执行，清空temp里对应uid事件，重新生成
    local time = os.time()
    if(isSameDay(time,temp[msg.uid].next_weekly.generate_time) == false)then
        table.clear(temp[msg.uid].weekly_done)
        temp[msg.uid].next_weekly.generate_time = nil
        temp[msg.uid].next_weekly.num = nil
        temp[msg.uid].next_weekly.is_exam = 0;
    else(temp[msg.uid].next_weekly.generate_time=="nil" or isSameDay(time,temp[msg.uid].next_weekly.generate_time))then
        if(temp[msg.uid].next_weekly.generate_time!="nil")then--把上一次的存在里
            table.insert(temp[msg.uid].weekly_done,temp[msg.uid].next_weekly.num)
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
            if(player[msg.uid].Semeste>event[Weekly][formattedString].)then
                flag=1
            end
        end
        
        temp[msg.uid].next_weekly.generate_time = time
        temp[msg.uid].next_weekly.num = formattedString
        temp[msg.uid].next_weekly.is_exam = 0;
    end

end



-----------查找事件功能-----------
function search_event(msg)

    if(temp[msg.uid].next_daily.generate_time==nil)generate_day(msg);
    if(temp[msg.uid].next_weekly.generate_time==nil)generate_week(msg);

    s = "今日已完成事件：\n"
    --查看已完成事件
    s = s.."  每日事件：\n"
    for i = 0, #temp[msg.uid].daily_done do 
        s = s.."    "..event[Daily][temp[msg.uid].daily_done[i]].."\n"
    end
    s = s.."  每周事件：\n"
    for i = 0, #temp[msg.uid].weekly_done do 
        s = s.."    "..event[Weekly][temp[msg.uid].daily_done[i]].."\n"
    end

    if(temp[msg.uid].next_daily.is_exam==1)then 
        temp[msg.uid].next_weekly.generate_time = temp[msg.uid].next_daily.generate_time
        temp[msg.uid].next_weekly.num = temp[msg.uid].next_daily.num
        temp[msg.uid].next_weekly.is_exam = temp[msg.uid].next_daily.is_exam
    end
    if(temp[msg.uid].next_weekly.is_exam==1)then 
        temp[msg.uid].next_daily.generate_time = temp[msg.uid].next_weekly.generate_time
        temp[msg.uid].next_daily.num = temp[msg.uid].next_weekly.num
        temp[msg.uid].next_daily.is_exam = temp[msg.uid].next_weekly.is_exam
    end


    --查看下一项每日事件，以及相关具体信息
    if(temp[msg.uid].next_daily.is_exam==0)then
        s = s.."  下一项每日事件："..event[Daily][temp[msg.uid].next_daily.num].."\n"
    end
    --查看下一项每周事件，以及相关具体信息
    if(temp[msg.uid].next_daily.is_exam==0)then
        s = s.."  下一项每周事件："..event[Weekly][temp[msg.uid].next_weekly.num].."\n"
    end
    --考试的话
    if(temp[msg.uid].next_daily.is_exam==1)then 

    end

    return s
end




---------执行每日事件功能---------
function execute_day(msg)
    --判断是否触发随机事件


    --判断事件是否执行成功


    --更新参数，维护数据库
end


---------执行每周事件功能---------
function execute_day(msg)

    --判断是否够学分，若够学分触发考试事件


    --如果不够学分正常执行每日事件


    --判断事件是否执行成功


    --更新参数，维护数据库
end
