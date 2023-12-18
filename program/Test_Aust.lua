test = "测试"
config = {
    msg = {
    }
}

msg_order = {}
msg_order[test] = "AutoTest"

function sleep(seconds)
    os.execute("sleep " .. seconds)
end

function AutoTest()
    test1()         ---帮助界面测试
    sleep(3)       
    test2()         ---test2到test8为实现角色创建的测试
    sleep(3)
    test3()
    sleep(3)
    test4()
    sleep(3)
    test5()
    sleep(3)
    test6()
    sleep(3)
    test7()
    sleep(3)
    test8()
    sleep(3)
    test9()         ---test9为简介修改测试
    sleep(3)        
    test10()        ---test10为档案查看测试
    sleep(3)
    test11()        ---test11为签到功能测试
    sleep(3)
    test12()        ---test12到test17为事件的测试
    sleep(3)
    test13()
    sleep(3)
    test14()
    sleep(3)
    test15()
    sleep(3)
    test16()
    sleep(3)
    test17()
    sleep(3)
    test18()        ---test18到test30为社交的测试
    sleep(3)        ---test19到test23为社交中留言板的测试
    test19()
    sleep(3)
    test20()
    sleep(3)
    test21()
    sleep(3)
    test22()
    sleep(3)
    test23()
    sleep(3)
    test24()        ---test24到test30为社交中漂流瓶的测试
    sleep(3)
    test25()
    sleep(3)
    test26()
    sleep(3)
    test27()
    sleep(3)
    test28()
    sleep(3)
    test29()
    sleep(3)
    test30()
    sleep(3)
    test31()        ---test31到test32为查看学分的测试
    sleep(3)
    test32()
    sleep(3)
    test33()        ---test33为新内容测试
    sleep(3)
    test34()        ---test34到test36为查看成就的测试
    sleep(3)
    test35()
    sleep(3)
    test36()
    sleep(3)
    test37()        ---test37为查看积分测试 
    sleep(3)
    test38()        ---test38为查看继承码测试
    sleep(3)
    test39()        ---test39到test42为商店测试
    sleep(3)
    test40()
    sleep(3)
    test41()
    sleep(3)
    test42()
    sleep(3)
    test43()        ---test43到test45为背包测试
    sleep(3)
    test44()
    sleep(3)
    test45()
    sleep(3)

    return "测试结束"
end

function test1()
    return "帮助\ n"  
end

function test2()
    return "创建新角色"

end

function test3()
    return "新角色"
end

function test4()
    return "姓名 玩家"      --姓名后为玩家姓名
end

function test5()
    return "男"             --或女
end

function test6()
    return "职业 学生"       --职业一般为学生
end

function test7()
    return "随机"            --也可通过分配+四项属性值确定
end

function test8()
    return "是"              --确定角色创建
end

function test9()
    return "简介 简介内容"    --以简介 简介内容的方式修改简介
end

function test10()
    return "档案"            
end

function test11()
    return "签到"
end

function test12()
    return "go"
end

function test13()
    return "生成每日事件"
end

function test14()
    return "生成每周事件"
end

function test15()
    return "事件查看"
end
function test16()
    return "执行每日事件"
end

function test17()
    return "执行每周事件"
end

function test18()
    return "社交"       ---此处会出现留言板和漂流瓶两个选择
end

function test19()
    return "留言板"     ---留言板内容
end

function test20()
    return "书写留言 留言"  ---书写留言+留言内容输入留言
end

function test21()
    return "留言现形"       ---查看所有留言
end

function test22()
    return "我的留言"       ---查看自己的留言
end

function test23()
    return "擦除留言"
end

function test24()
    return "漂流瓶"         ---漂流瓶模块
end

function test25()
    return "扔漂流瓶"
end

function test26()
    return "扔漂流瓶 内容"      ---扔漂流瓶+内容的形式输入漂流瓶内容
end

function test27()
    return "捡漂流瓶"           
end

function test28()
    return "跳进海里"           ---可以查看漂流瓶数量，不过会“深入海底”
end

function test29()
    return "查找瓶子"
end

function test30()
    return "删除瓶子"
end

function test31()
    return "查看学分"
end

function test32()
    return "学分排行"
end

function test33()
    return "新内容"
end

function test34()
    return "查看成就"
end

function test35()
    return "已解锁"
end

function test36()
    return "未解锁"
end

function test37()
    return "查看积分"
end

function test38()
    return "查看继承码"
end

function test39()
    return "商店"
end

function test40()
    return "积分商店"       ---此处可选择成就商店，但需要某些条件
end

function test41()
    return "购买道具 肥宅快乐水"        ---购买道具+道具名的方法购买道具
end

function test42()
    return "成就商店"
end

function test43()
    return "背包"
end

function test44()
    return "查看道具 肥宅快乐水"        ---查看道具+道具名的方式查看道具内容
end

function test45()
    return "使用道具 肥宅快乐水"        ---使用道具+道具名的方式使用道具
end