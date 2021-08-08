
module TomlFormatterModule
    def format(tomlFilePath)
        return if !File::exist?(tomlFilePath)
        
        # ヘッダーのコメント行の出力
        outputLines = []
        outputLines << "##########################################################################################################\n"
        outputLines << "# [IMPORTANT]\n"
        outputLines << "#   !!!DO NOT EDIT THIS FILE!!!\n"
        outputLines << "#   This file was generated by AnimationFileRelocator.\n"
        outputLines << "#   Every time you run, this file will be deleted and re-generated.\n"
        outputLines << "#\n"
        outputLines << "# [About this file]\n"
        outputLines << "#   The characters enclosed in [] are the section names (Toml format)\n"
        outputLines << "#   The section name is created for each animation folder.\n"
        outputLines << "#   Under the section name, all information are listed including folder location, animation files, etc...\n"
        outputLines << "#\n"
        outputLines << "# [How to]  \n"
        outputLines << "#   If you want to manage DAR Custom Conditions, the section name is required for csv culumn 1.\n"
        outputLines << "#   All listed animation files are relocated to the DAR custom condition folder.\n"
        outputLines << "#\n"
        outputLines << "#   If you want to run Hkanno.exe automatically, add or modify the following lines.\n"
        outputLines << "#     e.g)\n"
        outputLines << "#      hkannoPreset = \"My_Preset\"                                # Specify the foldername below \"Hkanno\" folder.\n"
        outputLines << "#      skysa_powersword1.sourceFileName = \"1hm_attackpower.hkx\" \n"
        outputLines << "#      skysa_powersword1.hkannoConfig = \"Anno.txt\"               # Specify the Annotation text file below the \"My_Preset\" folder.\n"
        outputLines << "#\n"
        outputLines << "#   For more informations, check my github page.\n"
        outputLines << "#     <https://github.com/RedGreenUnit/DAR-AnimationFileRelocator>\n"
        outputLines << "#\n"
        outputLines << "##########################################################################################################\n"
        
        
        # 生成されたTomlファイルを読みやすくする
        regExp=Regexp.compile("\\[.*?\\]") # セクション名の正規表現
        sectionNameSub=""
        File.open(tomlFilePath, "r") do |file|
            file.each {|line| 
                matchResult = regExp.match(line)
                if !matchResult.nil?                # セクション名の行
                    if line.split(".")[1].nil?      # アニメーション置き場ごとのセクション名の行
                        outputLines << "\n"
                        outputLines << "\n"
                        outputLines << line
                        sectionNameSub = ""
                    else                            # アニメーションファイルのセクション名の行
                        sectionNameSub = line.split(".")[1].gsub("\n", "").gsub("]", "")    # 各アニメーションファイル名をサブセクション名とする
                    end
                else
                    if sectionNameSub == ""         # アニメーション置き場ごとのセクションの値
                        outputLines << line
                    else                            # アニメーションファイルのセクションの値
                        outputLines << "    " + sectionNameSub + "." + line
                    end
                end
            }
        end

        File::delete(tomlFilePath)
        File.open(tomlFilePath, "w") do |file|
            outputLines.each {|line| file << line }
        end
    end
    module_function :format
end
