=begin
  title  RGDirectXP

  author jubin-park
  date   2020.04.04

  credit invwindy and Fux2 (RGDirect)
         joe59491, LiTTleDRAgo, and KK20 (Loading RTP Path)
         ForeverZer0 (Custom Resolution - Tilemap)
         PK8 and PhoenixFire (Windowskin Converter)
         Enterbrain (RPG module)
         unknown scripters (Ruby 1.8 Methods)

  desc   RGDirectXP is compatible with RGD in RPG Maker XP, in other words, you can use DirectX with RPGXP.
         To use RGDirectXP, you should have already RPGVXACE product as well as RPGXP. Because RGD uses RGSS301.dll library.
         RGDirectXP DOES NOT offer RGD's Game.exe file. Compatibility scripts ONLY.
         To get Game.exe file and more information, please visit below RGD-developer's website link.

         http://invwindy.mist.so/archives/290

=end

module RGDXP; module Config

  # 해상도
  Graphics.resize_screen(640, 480)
  # 시작 시 전체화면 
  FULLSCREEN_WHEN_START = false
  # ALT + ENTER 키 허용 여부
  ENABLE_KEY_ALT_ENTER = true

  # 백그라운드 실행
  Graphics.background_exec = true
  
  # 수직 동기화
  Graphics.vsync = true
  # 프레임
  Graphics.frame_rate = 60
  
  # 글꼴
  Font.default_name = "Arial"
  Font.default_size = 22
  Font.default_bold = false
  Font.default_italic = false
  Font.default_color = Color.new(255, 255, 255)
  Font.default_shadow = false
  Font.default_outline = false
  Font.default_out_color = Color.new(0, 0, 0, 128)

  # 디버그 콘솔 윈도우
  module ConsoleWindow
    # 실행 여부
    VISIBLE = true
    # 이름
    NAME = "RGSS Console"
  end

  # ForeverZer0's Tilemap
  module Tilemap
    # 오토타일 프레임 속도
    UPDATE_COUNT = 16
    # 맵 캐시 저장 여부
    PRE_CACHE_DATA = true
    # 해상도 로그 저장 여부
    RESOLUTION_LOG = true
  end

  # RTP 설정
  module LoadRTPFile
    RMXP  = true 
    RMVX  = true
    RMVXA = true
  end

end; end