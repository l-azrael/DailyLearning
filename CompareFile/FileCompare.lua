require("comd")
tabArg = command_func.comd(arg)
strFristFile = tabArg["inputFile1"]
strSecondFile = tabArg["inputFile2"]
strCompareFile = tabArg["outputFile"]
if strFristFile == nil or strSecondFile == nil then
	print("You do not enter the comparison file A or B / A and B, please check the command line parameters!")
	print("eg: comand + -i a.txt b.txt -o c.txt")
	return
end

--根据命令行参数输入相关的文件命令
require("comp")
tabFilePointer = {}
openFile_func.openFile(strFristFile, strSecondFile, strCompareFile, tabFilePointer)

--判断文件是否为空 或者说文件是否打开成功
if tabFilePointer[1] == nil and tabFilePointer[2] == nil then	
	print("file open failure/file is not exist!")
	return 0
elseif tabFilePointer[1] == nil then
	print(strFristFile, "文件指针为nil!")
	return 0
elseif tabFilePointer[2] == nil then
	print(strSecondFile, "文件指针为nil!")
	return 0
end

--读文件并做比较
openFile_func.readFileAndComp(tabFilePointer)

tabFilePointer[1]:close()
tabFilePointer[2]:close()
tabFilePointer[3]:close()




