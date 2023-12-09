event.good_morning = {    
    title = "早安",
    trigger = {
        clock = { --在每日指定时点触发，可设置多个时点
            {hour=6,minute=0}
        }
    },
    --调用script/daily/good_morning.lua
    action = { lua = "good_morning" } 
}
