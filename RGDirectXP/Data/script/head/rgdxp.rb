module RGDXP

  RegisterHotKey            = Win32API.new('user32', 'RegisterHotKey', 'llll', 'l')
  AllocConsole              = Win32API.new('kernel32', 'AllocConsole', 'v', 'l')
  SetForegroundWindow       = Win32API.new('user32', 'SetForegroundWindow', 'l', 'l')
  SetConsoleTitle           = Win32API.new('kernel32','SetConsoleTitleA', 'p', 'l')
  GetConsoleWindow          = Win32API.new('kernel32', 'GetConsoleWindow', 'v', 'l')
  GetCommandLine            = Win32API.new("kernel32", "GetCommandLine", "v", "p")
  SetWindowPos              = Win32API.new('user32', 'SetWindowPos', 'iiiiiii', 'i')
  GetWindowText             = Win32API.new('user32', 'GetWindowText', 'lpl', 'l')
  GetWindowTextLength       = Win32API.new('user32', 'GetWindowTextLength', 'l', 'l')

  module_function

  def init
    set_debug_mode
    set_default_font
    show_console_window if $DEBUG || $TEST
    disable_key_f10
  end

  def set_debug_mode
    argv = GetCommandLine.call.split
    $DEBUG = $TEST = (argv[1] == 'debug')
  end

  def set_default_font
    Font.default_name = "Arial"
    Font.default_size = 22
    Font.default_bold = false
    Font.default_italic = false
    Font.default_shadow = false
    Font.default_outline = false
    Font.default_color = Color.new(255, 255, 255, 255)
    Font.default_out_color = Color.new(0, 0, 0, 128)
  end

  def show_console_window
    AllocConsole.call
    $stdout.reopen('CONOUT$')
    SetForegroundWindow.call(Graphics.window_hwnd)
    SetConsoleTitle.call("#{get_caption << " - " << Config::CONSOLE_WINDOW_NAME}".to_m)
  end

  def disable_key_f10
    RegisterHotKey.call(Graphics.window_hwnd, 0, 0, 0x79)
  end

  def get_caption
    length = GetWindowTextLength.call(Graphics.window_hwnd)
    str = "\0" * (length)
    GetWindowText.call(Graphics.window_hwnd, str, length + 1)
    return str
  end
end

RGDXP.init