# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :shell do 
  watch( /json\/(.*).swift/) do 
    puts ""
    puts ""
    puts "*************** *************** *************** ***************"
    puts "*************** *************** *************** ***************"
    puts "*************** *************** *************** ***************"
    puts ""
    puts ""
    puts `xcodebuild -configuration Debug && $HOME/src/json/build/Debug/json`
  end
end
