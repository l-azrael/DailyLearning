openFile_func = {}

function openFile_func.openFile(strFristFile, strSecondFile, strCompareFile, tabFilePointer)
	--判断参数
	if strFristFile == nil or strSecondFile == nil then
		print("You do not enter the comparison file A or B / A and B, please check the command line parameters!")
		return 0
	end

	tabFilePointer[1] = io.open(strFristFile, "r")
	tabFilePointer[2] = io.open(strSecondFile, "r")

	if strCompareFile ~= nil then
		tabFilePointer[3] = io.open(strCompareFile, "w")
	else
		tabFilePointer[3] = io.open("CompareFile.txt", "w")
	end
end

function openFile_func.readFileAndComp(tabFilePointer)
	local lineNum = 0
	local strFirstLine = '\0'
	local strSecondLine = '\0'
	tabDiffCompareFile1 = {""}
	tabDiffCompareFile2 = {""}

	--对比行 具体到字符
	while strFirstLine ~= nil and strSecondLine ~= nil do
		if strFirstLine ~= strSecondLine then	
			tabDiffCompareFile1 = {""}
			tabDiffCompareFile2 = {""}
			local tmpNumChar = 1;
			openFile_func.CompareStringChar(strFirstLine, strSecondLine, tabDiffCompareFile1, tabDiffCompareFile2)
			diffLen1 = table.getn(tabDiffCompareFile1) 
			diffLen2 = table.getn(tabDiffCompareFile2)
			local readDiffFileLineNum = 0
			if diffLen1 > diffLen2 then
				readDiffFileLineNum = diffLen2
			else
				readDiffFileLineNum = diffLen1
			end

			for i = 1, readDiffFileLineNum do
				tabFilePointer[3]:write(strFristFile, "第", lineNum, "行\"", tabDiffCompareFile1[i], " \" 和", strSecondFile, "\" ", tabDiffCompareFile2[i], " \" 不同\n")
				i = i + 1
				tmpNumChar = i
			end

			--同行不同字数
			--diff1 行数 > diff2行数
			if readDiffFileLineNum == diffLen2 and tabDiffCompareFile1[tmpNumChar] ~= nil then
				tabFilePointer[3]:write(strFristFile, "第", lineNum, "行\"", tabDiffCompareFile1[tmpNumChar], " \" 和", strSecondFile, "为空不同\n")
			--diff1 行数 <= diff2行数
			else
				if diffLen1 < diffLen2 and tabDiffCompareFile2[tmpNumChar] ~= nil then
					tabFilePointer[3]:write(strFristFile, "第", lineNum, "行为空,和 ", strSecondFile, ": \" ", tabDiffCompareFile2[tmpNumChar], " \" 不同\n")
				end
			end

		end
		strFirstLine = tabFilePointer[1]:read("*l")
		strSecondLine = tabFilePointer[2]:read("*l")
		lineNum = lineNum + 1
	end

	--文件行数不一样的情况 
	if strFirstLine == nil and strSecondLine == nil then
		print("file is null/ line is equal!")
	elseif strFirstLine == nil then
		local tempLine = strSecondLine;
		strSecondLine = tabFilePointer[2]:read("*a")
		strWrite = tempLine..strSecondLine
		tabFilePointer[3]:write(strFristFile, "第", lineNum, "行为空, 和", strSecondFile, "显示为：\" ", strWrite, " \" 不同\n")
	elseif strSecondLine == nil then
		local tempLine = strFirstLine
		strFirstLine = tabFilePointer[1]:read("*a")
		strWrite = tempLine..strFirstLine
		tabFilePointer[3]:write(strSecondFile,  "第", lineNum, "行为空, 和", strFristFile, "显示为：\"", strWrite, " \" 不同\n")
	end	
end

function openFile_func.CompareStringChar(strFirstLine, strSecondLine, tabDiffCompareFile1, tabDiffCompareFile2)
	local boolWrite = false
	local tabNum = 1
	tabStringFrist = {}
	tabStringSecond = {}

	openFile_func.GetUTF8Chars(strFirstLine, tabStringFrist)
	openFile_func.GetUTF8Chars(strSecondLine, tabStringSecond)

	tabFirstLen = table.getn(tabStringFrist)
	tabSecondLen = table.getn(tabStringSecond)

	if tabFirstLen < tabSecondLen then
		loopLen = tabFirstLen
	else
		loopLen = tabSecondLen
	end

	for i = 0, loopLen, 1 do
		charFile1 = tabStringFrist[i]
		charFile2 = tabStringSecond[i]
		if charFile1 == charFile2 then
			--同一行几处不同点
			if boolWrite == true then
				tabNum = tabNum + 1
				boolWrite = false
			end
			i = i + 1
		else
			
			if boolWrite == false then
				tabDiffCompareFile1[tabNum] = ""
				tabDiffCompareFile2[tabNum] = ""
			end
			tabDiffCompareFile1[tabNum] = tabDiffCompareFile1[tabNum]..charFile1
			tabDiffCompareFile2[tabNum] = tabDiffCompareFile2[tabNum]..charFile2
			i = i + 1
			boolWrite = true
		end
	end

--行长度不统一
	local diffString = ""
	if tabFirstLen < tabSecondLen then
		local num = tabFirstLen + 1
		while num <= tabSecondLen do
			diffString = diffString .. tabStringSecond[num]
			num = num + 1
		end
		if tabDiffCompareFile2[tabNum] ~= nil then
			tabDiffCompareFile2[tabNum + 1] = ""
			tabDiffCompareFile2[tabNum + 1] = diffString
		else
			tabDiffCompareFile2[tabNum] = ""
			tabDiffCompareFile2[tabNum]  = diffString
		end
	else	
		local num = tabSecondLen + 1
		while num <= tabFirstLen do
			diffString = diffString .. tabStringFrist[num]
			num = num + 1
		end
		if tabDiffCompareFile1[tabNum] ~= nil then
			tabDiffCompareFile1[tabNum + 1] = ""
			tabDiffCompareFile1[tabNum + 1] = diffString
		else
			tabDiffCompareFile1[tabNum] = ""
			tabDiffCompareFile1[tabNum] = diffString
		end
	end
end

function  openFile_func.GetUTF8Chars(str, tabstring)	
	local bytelen = string.len(str)
	if bytelen == 0 then return "" end
	local chars = {}
	local dropping, i, count = 0, 1, 1
	while(i <= bytelen) do
		dropping = string.byte(str, i)
		if dropping >= 240 then
			tabstring[count] = string.sub(str, i, i+3)
			i = i + 4
		elseif dropping >= 224 then
			tabstring[count] = string.sub(str, i, i+2)
			i = i + 3
		elseif dropping >= 192 then
			tabstring[count] = string.sub(str, i, i+1)
			i = i + 2
		else
			tabstring[count] = string.sub(str, i, i)
			i = i + 1
		end
		count = count + 1
	end
	return chars
end


return openFile_func