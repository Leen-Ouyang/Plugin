
--以下是关键词，修改后需要重载
day = "day"
week = "week"
all = "all"
done = "done"
dodaily = "dodaily"
doweekly = "doweekly"
--以下是插件配置，修改后无需重载

all_event = "Event.json"
player_event = ""

config = {
    dis_priv = true,--禁用小窗
    init_daily_max = 1;
    
    
    msg = {--下面是回复词
        already_used = "今天已经执行过每日事件了，不能再执行了"
    }
}
--↑↑↑↑↑↑上面是配置部分↑↑↑↑↑↑
msg_order = {}
msg_order[day] = "search_daily_event"
msg_order[week] = "search_weekly_event"
msg_order[all] = "not_yet_down"
msg_order[done] = "haven_down"
msg_order[dodaily] = "execute_daily_event"
msg_order[doweekly] = "execute_weekly_event"

all_Event = getSelfData(all_event)
data = getSelfData(event_name)
dailyEvent = data:get(nil,{});

if(dailyEvent == nil)then
    dailyEvent={}
end

function init_daily_event(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end
    if(getUserToday(msg.fromQQ,"DB_everyday_event",0)<config.init_daily_max)then
        eventid = random(0,99)--随机生成一个每日事件
        player_event[msg.fromQQ].daily_event_id = math.random(100, 199) -- 生成1到100之间的随机数
        player_event[msg.fromQQ].daily_event_lasttime = os.time()      -- 更新时间
        player_event[msg.fromQQ].daily_event_used = 0
        data:set(player_event)
        setUserToday(msg.fromQQ, "DB_everyday_event", getUserToday(msg.fromQQ, "DB_everyday_event", 0)+1)
    end
    
end


-- 获取当前时间的周数
local function getWeekNumber(time)
    local janFirst = os.time{year=os.date("*t", time).year, month=1, day=1}
    local janFirstWeekDay = os.date("*t", janFirst).wday
    local dayOffset = (janFirstWeekDay <= 2) and (8 - janFirstWeekDay) or (2 - janFirstWeekDay)
    return math.floor(((os.difftime(time, janFirst) / (24 * 60 * 60)) + dayOffset) / 7)
end

-- 检查是否需要生成新的随机数
local function shouldGenerateNewNumber()
    local currentTime = os.time()
    local currentWeek = getWeekNumber(currentTime)
    local lastGeneratedWeek = dataStore.lastGeneratedTime and getWeekNumber(dataStore.lastGeneratedTime) or nil

    -- 如果从未生成过，或者当前周数小于上次生成的周数，
    -- 或者周数相同但当前时间小于上次生成时间，
    -- 或者当前时间距离上次生成超过一周
    if not lastGeneratedWeek or 
       currentWeek < lastGeneratedWeek or 
       (currentWeek == lastGeneratedWeek and currentTime < dataStore.lastGeneratedTime) or 
       (os.difftime(currentTime, dataStore.lastGeneratedTime) >= 7 * 24 * 60 * 60) then
        return true
    end
    return false
end

-- 生成并保存一个新的随机数
function init_weekly_event(msg)
    if shouldGenerateNewNumber() then
        player_event[msg.fromQQ].weekly_event_id = math.random(100, 199) -- 生成100到199之间的随机数
        player_event[msg.fromQQ].weekly_event_lasttime = os.time()      -- 更新时间
        player_event[msg.fromQQ].weekly_event_used = 0
        data:set(player_event)
    end
end


function search_daily_event(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end
    init_daily_event(msg)
    
    
    local daily_id=player_event[msg.fromQQ].daily_event_id
    
    return --事件所有内容
    
end

function search_weekly_event(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end
    init_weekly_event(msg)
    local weekly_id=player_event[msg.fromQQ].weekly_event_id
    return --事件所有内容
end

function not_yet_down(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end
    init_weekly_event(msg)
    init_daily_event(msg)
    local daily_id=player_event[msg.fromQQ].daily_event_id
    local weekly_id=player_event[msg.fromQQ].weekly_event_id

    if(player_event[msg.fromQQ].daily_event_used==0 and player_event[msg.fromQQ].weekly_event_used == 0)then
        return "未执行任务:每日任务、每周任务\n"
    elseif(player_event[msg.fromQQ].daily_event_used==1 and player_event[msg.fromQQ].weekly_event_used == 0)then
        return "未执行任务:每周任务\n"
    elseif(player_event[msg.fromQQ].daily_event_used==0 and player_event[msg.fromQQ].weekly_event_used == 1)then
        return "未执行任务:每日任务\n"
    else
        return "太棒了，你已经执行完全部任务了\n"
end


function haven_down(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end
    init_weekly_event(msg)
    init_daily_event(msg)
    local daily_id=player_event[msg.fromQQ].daily_event_id
    local weekly_id=player_event[msg.fromQQ].weekly_event_id

    
    if(player_event[msg.fromQQ].daily_event_used==0 and player_event[msg.fromQQ].weekly_event_used == 0)then
        return "已执行任务：无\n"
    elseif(player_event[msg.fromQQ].daily_event_used==1 and player_event[msg.fromQQ].weekly_event_used == 0)then
        return "已执行任务：每日任务\n"
    elseif(player_event[msg.fromQQ].daily_event_used==0 and player_event[msg.fromQQ].weekly_event_used == 1)then
        return "已执行任务：每周任务\n"
    else
        return "已执行任务：每日任务、每周任务\n"

end


function execute_daily_event(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end

    

    init_daily_event(msg)
    local pos1;
    for i=#dailyEvent,1,-1 do
        if(dailyEvent.QQ==search_qq)then
            pos1=dailyEvent.event_id
            used1=dailyEvent.used
            break
        end
    end

    if(used1==1)
        return config.msg.already_used

    if()then --判断是否考试
        --跳转到考试的那里
    end

    --如果不是考试，判断是否触发随机事件

    --判断是否成功

    --成功就更新玩家属性

end

function execute_weekly_event(msg)
end
