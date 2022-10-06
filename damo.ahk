#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance force
dm:= ComObjCreate("dm.dmsoft")
ver:=dm.ver()
MsgBox,,,%ver%注册成功！,1

sleep,2000

;获取鼠标所在的窗口句柄
hwnd:=dm.getmousepointwindow()

;初始化配置
a:=dm.SetPath("D:\test")  ;把全局路径设置到了D盘test目录
b:=dm.SetDict(0,"test.txt")  ;设置字库文件,此函数速度很慢，全局初始化时调用一次即可，切换字库用UseDict


;绑定指定的窗口
dm_bding:= dm.BindWindow(hwnd,"normal","normal","normal",0)  ;display: 前台 鼠标:前台 键盘:前台 模式0

if dm_bding = 1
   msgbox,,,绑定成功！,1
sleep,1000
global dm

x:=ComVar()
y:=ComVar()
dm_ret:= dm.FindStrFast(0,0,150,80,"目录","000000-000000",1.0,x.ref,y.ref)
dm.MoveTo(x[],y[])
sleep,1000
dm.LeftClick
dm.LeftClick
dm.MoveTO(246,643)

sleep,1000

;截图保存到设置的路径文件夹中
dm_bmp:=dm.Capture(0,0,600,600,"screen.bmp")

sleep,1000

;解除绑定窗口
dm.Unbindwindow
exitapp


;========= 高级函数 让内部代码处理在 VARIANT 和 AutoHotkey 内部类型之间的所有转换============


; ComVar: 创建用来传递 ByRef 值的对象.
;   ComVar[] 检索值.
;   ComVar[] := Val 设置值.
;   ComVar.ref 检索 ByRef 对象用于传递到 COM 函数.
ComVar(Type=0xC)
{
    static base := { __Get: "ComVarGet", __Set: "ComVarSet", __Delete: "ComVarDel" }
    ; 创建含 1 个 VARIANT 类型变量的数组.  此方法可以让内部代码处理
    ; 在 VARIANT 和 AutoHotkey 内部类型之间的所有转换.
    arr := ComObjArray(Type, 1)
    ; 锁定数组并检索到 VARIANT 的指针.
    DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(arr), "ptr*", arr_data)
    ; 保存可用于传递 VARIANT ByRef 的数组和对象.
    return { ref: ComObjParameter(0x4000|Type, arr_data), _: arr, base: base }
}
ComVarGet(cv, p*) 
{
    ; 当脚本访问未知字段时调用.
    if(p.MaxIndex() = "") ; 没有名称/参数, 即 cv[]
    {
        return cv._[0]
    }
}
ComVarSet(cv, v, p*) 
{ 
    ; 当脚本设置未知字段时调用.
    if(p.MaxIndex() = "") ; 没有名称/参数, 即 cv[]:=v
    {
        return cv._[0] := v
    }
}
ComVarDel(cv) 
{
    ; 当对象被释放时调用.
    ; 必须进行这样的处理以释放内部数组.
    DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(cv._))
}











