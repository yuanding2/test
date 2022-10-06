#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;
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

dm.MoveTO(576,376)

sleep,1000

;截图保存到设置的路径文件夹中
dm_bmp:=dm.Capture(0,0,600,600,"screen.bmp")

sleep,1000

;解除绑定窗口
dm.Unbindwindow


