module RGDXP

  RegisterHotKey            = Win32API.new('user32', 'RegisterHotKey', 'llll', 'l')
  AllocConsole              = Win32API.new('kernel32', 'AllocConsole', 'v', 'l')
  SetForegroundWindow       = Win32API.new('user32', 'SetForegroundWindow', 'l', 'l')
  SetConsoleTitle           = Win32API.new('kernel32','SetConsoleTitle', 'p', 'l')
  GetConsoleWindow          = Win32API.new('kernel32', 'GetConsoleWindow', 'v', 'l')
  GetCommandLine            = Win32API.new("kernel32", "GetCommandLine", "v", "p")
  SetWindowPos              = Win32API.new('user32', 'SetWindowPos', 'iiiiiii', 'i')
  GetWindowText             = Win32API.new('user32', 'GetWindowText', 'lpl', 'l')
  GetWindowTextLength       = Win32API.new('user32', 'GetWindowTextLength', 'l', 'l')

  module_function

  def init
    set_debug_mode
    show_console_window if $DEBUG || $TEST
    disable_key_f10
    Graphics.toggle_fullscreen if Config::FULLSCREEN_WHEN_START && !Graphics.is_fullscreen?
  end

  def set_debug_mode
    argv = GetCommandLine.call.split
    $DEBUG = $TEST = (argv[1] == 'debug')
  end

  def show_console_window
    return if Config::ConsoleWindow::VISIBLE != true
    AllocConsole.call
    $stdout.reopen('CONOUT$')
    SetForegroundWindow.call(Graphics.window_hwnd)
    SetConsoleTitle.call(get_caption << " - " << Config::ConsoleWindow::NAME.to_m)
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