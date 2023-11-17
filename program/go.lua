go = "go"
config = {
    msg = {
        eventmenu="╔══════════════════╗\n               事件选择\n   ———————————\n   指令：\n    「执行每周事件」\n    「执行每日事件」\n    「生成每日事件」\n    「生成每周事件」\n    「事件查看」\n╚══════════════════╝\ntips:解锁特定成就可选择教师等其他职业"
    }
}
msg_order = {}
msg_order[go] = "Eventmenu"
function Eventmenu(msg)
    return config.msg.eventmenu
end