go = "go"
config = {
    msg = {
        eventmenu="╔══════════════════╗\n               事件选择\n   ———————————\n   指令            效果\n 「dodaily」  每日事件→\n 「doweekly」每周事件→\n 「day」        每日事件列表\n 「week」      每周事件列表\n 「all」         本周未完成列表\n 「done」      已完成列表\n╚══════════════════╝\ntips:解锁特定成就可选择教师等\n         其他职业"
    }
}
msg_order = {}
msg_order[go] = "Eventmenu"
function Eventmenu()
    return config.msg.eventmenu
end