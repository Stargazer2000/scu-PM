import imgui
import imgui_font
using imgui
# 因为每次执行都会生成对应文件，为防止相互影响，先删除改文件。
system.file.remove("./imgui.ini")

#application对象，即一整个windows窗体，其内会包含很多的小窗体以实现功能
# 一般情况下一个程序只能有一个app实例
var app=window_application(get_monitor_width(0),get_monitor_height(0),"测试窗口")
# 只要app的属性不是关闭，就不会关闭最大的win窗口
# 作为GUI，是会不停的进行图形渲染的，即整个while循环不断地执行，不断地监听是否有事件发生，

#var app=window_application(0.75*imgui.get_monitor_width(0),0.75*imgui.get_monitor_height(0),"CovScript ImGUI测试程序")
# 上面这个是创建一个默认不满屏的窗体

var window_opened=true
# 很多情况下，执行绘图函数，需要通过形参列表返回值！！！！！（即需要“传引用得到返回值”）所以要定义这样的常量
while !app.is_closed()
    # 所有的app内的图形，窗体，必须在app的prepare函数（准备需要渲染的图形）和app.render()中间进行
    # 执行render后悔渲染一帧
    app.prepare()
        style_color_light()
        #设置为亮色调,还有两种为
        #style_color_dark()
        #style_color_classic()
        #对应文档3.2.2.3样式和字体

        #开始创建第一个窗口
        begin_window("Test Window",window_opened,{flags.no_title_bar})
        # 第三个参数，参见文档中的3.2.2.20窗口参数命名空间
        if !window_opened
            break
        end
        text("hello world")
        set_window_size(vec2(100,200))
        # 上面这个vec2是创建一个二维变量，（100,200），并将其作为参数传入set_window_size用以重设窗体大小。
        # 3.2.2.4中有关于窗口的所有性质，可以自行尝试
        end_window()
        # 结束本窗口
        app.render()
end