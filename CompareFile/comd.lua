command_func = {}

function command_func.comd(arg, str)
	tabComd = {""}
	flagInput = false
	flagOutPut = false
	flagComd = false
	for i, value in ipairs(arg) do
		if value == "-i" or value == "--input" or flagInput  then
			if value ~= "-o" and value ~= "--output" then
				if string.sub(value, 1, 1) ~= "-" then
					if tabComd["inputFile1"] ~= nil then
						if tabComd["inputFile2"] == nil then
							tabComd["inputFile2"] = value
						end
					else
						 tabComd["inputFile1"] = value
					end
				end
				flagInput = true
				flagOutPut = false
			end
			flagComd = true
		end

		if value == "-o" or value == "--output" or flagOutPut then
			flagComd = true
			if string.sub(value, 1, 1) ~= "-" then
				if tabComd["outputFile"] == nil then
					tabComd["outputFile"] = value
				end
			end
			flagOutPut = true
			flagInput = false
		end

		if flagInput then
			if tabComd["inputFile2"] ~= nil then
				tabComd["inputFile2"] = value
			end
			flagInput = true
			flagOutPut = false
		end

		--没有命令行参数
		if tagComd == false then
		tabArg["inputFile1"] = arg[1]
		tabArg["inputFile2"] = arg[2]
		tabArg["outputFile"] = arg[3]
	end
	end
	return tabComd

end
return command_func

