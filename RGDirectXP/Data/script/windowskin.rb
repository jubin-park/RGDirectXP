#───────────────────────────────────────────────────────────────────────────────
# * Window_Base
#───────────────────────────────────────────────────────────────────────────────
class Window_Base
  alias_method(:rmxptorgss3_initialize, :initialize) if !$@
  def initialize(*args)
    rmxptorgss3_initialize(*args)
    self.padding = 16
  end
end

=begin

 RMXP to RMVX (Ace) Windowskin Converter v1.0.4
 by PK8, PhoenixFire
 Created: 5/1/2012
 Modified: 1/28/2015
 ──────────────────────────────────────────────────────────────────────────────
 ■ Introduction and Notes
   I was in yet another experimental kind of mood and decided to script this.
   Mainly inspired by a web-based windowskin converter I wanted to do for my
   old site. This script will take whatever XP windowskin you give it and mould
   it into a windowskin that would fit right in with RPG Maker VX in-game.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Features
   o Very plug and play. Add this script in, change your windowskin to an
     XP windowskin, edit a couple of settings, and there you go! Methods 
     Aliased: Window_Base.initialize, Window_Base.update
 ──────────────────────────────────────────────────────────────────────────────
 ■ Changelog (MM/DD/YYYY)
    v1     (05/01/2012): Initial release.
    v1.0.1 (05/02/2012): I removed a setting. Instead of setting which area would
                        the script copy over to the bitmap, it would copy
                        certain areas depending on the filename. (Applies to XP)
    v1.0.2 (05/03/2012): Disposes the new_windowskin bitmap after it's done
                        generating the converted skin.
    v1.0.3 (05/05/2012): Added a compatibility setting for my windowskin script,
                        took out the compatibility flag setting, and added a
                        switch setting.
    v1.0.4 (06/12/2012): Reduced the code by a couple of lines.
    v1.0.4 (01/28/2015): Reduced the code by a couple of lines.
 ──────────────────────────────────────────────────────────────────────────────
 ■ Importing RPG Maker XP Windowskins
   o This script has been made to be used along with other windowskin changing
     scripts. To allow this script to be used along with other windowskin
     changers, set the Compatibility setting to anything other than false.
   o If the windowskin doesn't have a "$" or a "!" in its filename...
       It will apply the windowskin's wallpaper onto the background.
   o If the windowskin has a "$" in its filename
       It will apply the windowskin's wallpaper onto the background and pattern.
   o If the windowskin has a "!" in its filename
       It will apply the windowskin's wallpaper onto the pattern.
   
=end

module PK8
  class Windowskin_Conversion
    Colors = []
    Colors[0]  = [255, 255, 255]    # Normal Text Color
    Colors[1]  = [32 , 160, 214]
    Colors[2]  = [255, 120, 76]
    Colors[3]  = [102, 204, 64]
    Colors[4]  = [153, 204, 255]
    Colors[5]  = [204, 192, 255]
    Colors[6]  = [255, 255, 160]
    Colors[7]  = [128, 128, 128]
    Colors[8]  = [192, 192, 192]
    Colors[9]  = [32 , 128, 204]
    Colors[10] = [255, 56 , 16]
    Colors[11] = [0  , 160, 16]
    Colors[12] = [64 , 154, 222]
    Colors[13] = [160, 152, 255]
    Colors[14] = [255, 204, 32]
    Colors[15] = [0  , 0  , 0]
    Colors[16] = [132, 170, 255]    # System Text Color
    Colors[17] = [255, 255, 64]     # Crisis Color
    Colors[18] = [255, 32 , 32]     # Knockout Color
    Colors[19] = [32 , 32 , 64]     # Gauge Back Color
    Colors[20] = [224, 128, 64]     # HP Gauge Color 1
    Colors[21] = [240, 192, 64]     # HP Gauge Color 2
    Colors[22] = [64 , 128, 192]    # MP Gauge Color 1
    Colors[23] = [64 , 192, 240]    # MP Gauge Color 2 / MP Cost Color
    Colors[24] = [128, 255, 128]    # Power Up Color
    Colors[25] = [192, 128, 128]    # Power Down Color
    Colors[26] = [128, 128, 255]
    Colors[27] = [255, 128, 255]
    Colors[28] = [0  , 160, 64]     # TP Gauge Color 1
    Colors[29] = [0  , 224, 96]     # TP Gauge Color 2 / TP Cost Color
    Colors[30] = [160, 96 , 224]
    Colors[31] = [192, 128, 255]
  end
end
class Window_Base < Window
  unless method_defined?(:pk8_xpwindowskin_initialize)
    alias_method(:pk8_xpwindowskin_initialize, :initialize) if !$@
    alias_method(:pk8_xpwindowskin_update, :update) if !$@
  end
  def initialize(*args)
    pk8_xpwindowskin_initialize(*args)
    if self.windowskin.width == 192 and self.windowskin.height == 128
      new_windowskin = Bitmap.new(128, 128)
      new_windowskin.stretch_blt(Rect.new(0, 0, 64, 64), self.windowskin, Rect.new(0, 0, 128, 128))
      new_windowskin.blt(64, 0, self.windowskin, Rect.new(128, 0, 64, 96))
      for i in 0...PK8::Windowskin_Conversion::Colors.size
        column, row = i*8%64, ((i/8).abs)*8
        new_windowskin.fill_rect(64 + column, 96 + row, 8, 8, Color.new(*PK8::Windowskin_Conversion::Colors[i]))
      end
      self.windowskin = new_windowskin.clone
      new_windowskin.dispose
    end
  end
  def update
    pk8_xpwindowskin_update
  end
end
