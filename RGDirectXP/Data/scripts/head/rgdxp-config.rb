module RGDXP; module Config

  # 해상도
  Graphics.resize_screen(640, 480)
  # 시작 시 전체화면 
  FULLSCREEN_WHEN_START = false
  # 프레임
  Graphics.frame_rate = 60
  
  # 글꼴
  Font.default_name = "Arial"
  Font.default_size = 24
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