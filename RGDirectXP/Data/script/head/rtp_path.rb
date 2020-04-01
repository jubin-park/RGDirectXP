#===============================================================================
# Load RTP File
# Author: joe59491, edit by LiTTleDRAgo and KK20
# Version : 1.51
#-------------------------------------------------------------------------------
# [ Description ]
# Loads RMXP RTP assets so that the user does not have to manually import all of
# them into their project.
#
# As of Version 1.50, it loads the RTP based on the path stored in the registry.
#
# [ Instructions ]
# There is nothing to do here.
# Please keep this script in its current location.
#
# It is highly advised to not modify this script unless you know what you are
# doing.
#===============================================================================

module Load_RTP_File
  
  RMXP  = true 
  RMVX  = true
  RMVXA = true

end
 
#==============================================================================
# ** Ini
#------------------------------------------------------------------------------
# 　
#==============================================================================
module Ini
  #--------------------------------------------------------------------------
  # * self.readIni
  #--------------------------------------------------------------------------
  def self.readIni(item = "Title")
    buf = 0.chr * 256
    @gpps ||= Win32API.new("kernel32","GetPrivateProfileString","pppplp","l")
    @gpps.call("Game",item,"",buf,256,"Game.ini")
    buf.delete!("\0")
    return buf
  end
end

#==============================================================================
# ** String
#------------------------------------------------------------------------------
# 　
#==============================================================================
class String
  #--------------------------------------------------------------------------
  # ● UTF8_to_unicode
  #--------------------------------------------------------------------------
  def to_unicode  
    @mbytetowchar ||= Win32API.new("kernel32","MultiByteToWideChar",'ilpipi','I')
    len = @mbytetowchar.call(65001, 0, self, -1, 0, 0) << 1
    @mbytetowchar.call(65001, 0, self, -1, (buf = " " * len), len)
    return buf
  end
end

#==============================================================================
# ** RPG::Path
#------------------------------------------------------------------------------
# 　
#==============================================================================
module RPG
  module Path
    #--------------------------------------------------------------------------
    # * Constant
    #--------------------------------------------------------------------------
    FindFirstFile = Win32API.new("kernel32", "FindFirstFileW", "PP", "L") 
    FindNextFile  = Win32API.new("kernel32", "FindNextFileW", "LP", "I")
    ReadRegistry = Win32API.new("advapi32","RegGetValue","lppllpp","l")
    #--------------------------------------------------------------------------
    # * getRTPPath
    #--------------------------------------------------------------------------
    def self.getRTPPath(rgss,rtpname)
      return "" if rtpname == "" or rtpname.nil?
      # Get the registry value's length
      reg = [ 0x80000002, # HKEY_LOCAL_MACHINE
              "SOFTWARE\\Wow6432Node\\Enterbrain\\#{rgss}\\RTP",
              "#{rtpname}",
              2, # REG_SZ
              0, # Null
              0, # Null, so that we can get value's length
              (size = [256].pack("L")) ]
      ReadRegistry.call(*reg)
      buffer = size.unpack("L")[0]   # Length stored in 'size'
      path = reg[5] = "\0" * buffer  # Now we know how long the string is
      # Get the registry value itself
      ReadRegistry.call(*reg)
      path.delete!("\0")
      # Ensure trailing forward slash to path name
      path = (path + '/').gsub("\\","/").gsub("//","/")
      path 
    end
    #--------------------------------------------------------------------------
    # * Class Variable
    #--------------------------------------------------------------------------
    @@RTP = []
    if Load_RTP_File::RMXP
      @@RTP << self.getRTPPath('RGSS','Standard')
      (0..3).each do |i| 
        @@RTP << self.getRTPPath('RGSS',Ini.readIni("RTP#{i.to_s}")) 
      end 
    end  
    @@RTP << self.getRTPPath('RGSS2',"RPGVX")    if Load_RTP_File::RMVX
    @@RTP << self.getRTPPath('RGSS3',"RPGVXAce") if Load_RTP_File::RMVXA
    @@RTP.reject! {|rtp| rtp.nil? || rtp.empty?}
    #--------------------------------------------------------------------------
    # * self.findP
    #--------------------------------------------------------------------------
    def self.findP(*paths)
      findFileData = " " * 596
      result = ""
      for file in paths        
        unless FindFirstFile.call(file.to_unicode, findFileData) == -1
          name = file.split("/").last.split(".*").first
          result = File.dirname(file) + "/" + name
        end
      end
      return result
    end
    #--------------------------------------------------------------------------
    # * self.RTP
    #--------------------------------------------------------------------------
    def self.RTP(path)
      @list ||= {}
      return @list[path] if @list.include?(path)
      check = File.extname(path).empty?
      rtp = []
      @@RTP.each do |item|
        unless item.empty?
          rtp.push(item + path)
          rtp.push(item + path + ".*") if check
        end
      end
      rtp.push(path)
      rtp.push(path + ".*") if check
      pa = self.findP(*rtp)
      @list[path] = pa == "" ? path : pa
      return @list[path]
    end
  end
end

#==============================================================================
# ** Audio
#------------------------------------------------------------------------------
# 　
#==============================================================================
class << Audio
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  [:bgm_play,:bgs_play,:se_play,:me_play].each do |meth|
    $@ || alias_method(:"#{meth}_path", :"#{meth}")
    define_method(:"#{meth}") do |*args|
      args[0] = RPG::Path::RTP(args[0]) if args[0].is_a?(String)
      send(:"#{meth}_path",*args)
    end
  end
end

#==============================================================================
# ** Bitmap
#------------------------------------------------------------------------------
# 　
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # ● Alias Method
  #--------------------------------------------------------------------------
  $@ || alias_method(:rtp_path_init, :initialize)
  #--------------------------------------------------------------------------
  # ● Object Initialization
  #--------------------------------------------------------------------------
  def initialize(*args)
    args[0] = RPG::Path::RTP(args.at(0)) if args.at(0).is_a?(String)
    rtp_path_init(*args)
  end
end

#==============================================================================
# ** Graphics
#------------------------------------------------------------------------------
#  This module handles all Graphics
#==============================================================================
class << Graphics
  #--------------------------------------------------------------------------
  # ● Alias Method
  #--------------------------------------------------------------------------
  $@ || alias_method(:rtp_path_transition, :transition)
  #--------------------------------------------------------------------------
  # ● transition
  #--------------------------------------------------------------------------
  def transition(*args)
    args[1] = RPG::Path::RTP(args.at(1)) if args[1].is_a?(String)
    rtp_path_transition(*args)
  end
end