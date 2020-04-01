#===============================================================================
# ** Spriteset_Map
#===============================================================================
class Spriteset_Map

  alias init_for_centered_small_maps initialize
  #---------------------------------------------------------------------------
  # Resize and reposition viewport so that it fits smaller maps
  #---------------------------------------------------------------------------
  def initialize
    @center_offsets = [0,0]
    if $game_map.width < (Graphics.width / 32.0).ceil
      x = (Graphics.width - $game_map.width * 32) / 2
    else
      x = 0
    end
    if $game_map.height < (Graphics.height / 32.0).ceil
      y = (Graphics.height - $game_map.height * 32) / 2
    else
      y = 0
    end
    init_for_centered_small_maps
    w = [$game_map.width  * 32 , Graphics.width].min
    h = [$game_map.height * 32 , Graphics.height].min
    @viewport1.resize(x,y,w,h)
  end
  
end