# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :shell do 
  watch( /jsonLib\/(.*).swift/) do 
    puts ""
    puts ""
    puts "*************** *************** *************** ***************"
    puts "*************** *************** *************** ***************"
    puts "*************** *************** *************** ***************"
    puts ""
    puts ""
    puts `xcodebuild -sdk macosx10.10 -target jsonLib -configuration Debug`
  end

  watch( /jsonLibTests\/(.*).swift/) do 
    puts ""
    puts ""
    puts "*************** *************** *************** ***************"
    puts "*************** *************** *************** ***************"
    puts "*************** *************** *************** ***************"
    puts ""
    puts ""
    puts `xcodebuild -sdk macosx10.10 -scheme jsonLibTests test`
  end
end
