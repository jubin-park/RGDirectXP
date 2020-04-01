require "ruby18"
require "rpg"
require "rtp_path"
require "viewport"


getCommandLine_f = Win32API.new("Kernel32", "GetCommandLine", "", "P")
startupString = getCommandLine_f.call.split(' ')
if startupString[1] == 'debug'
  $DEBUG = $TEST = true
end

Font.default_name = "Arial"
Font.default_size = 22
Font.default_bold = false
Font.default_italic = false
Font.default_shadow = false
Font.default_outline = false
Font.default_color = Color.new(255, 255, 255, 255)
Font.default_out_color = Color.new(0, 0, 0, 128)
Graphics.resize_screen(640, 480)
Graphics.frame_rate = 60