#===============================================================================
# Custom Resolution
# Author: ForeverZer0
# Version: 0.93
# Date: 12.18.2010
#===============================================================================
#
# Introduction:
#
#   My goal in creating this script was to create a system that allowed the user
#   to set the screen size to something other than 640 x 480, but not have make
#   huge sacrifices in compatibility and performance. Although the script is
#   not simply Plug-and-Play, it is about as close as one can achieve with a 
#   script of this nature.
#
# Instructions:
#
#  - Place the "screenshot.dll" from Fantasist's Transition Pack script, which 
#    can be found here: http://www.sendspace.com/file/yjd54h in your game folder
#  - Place this script above main, below default scripts.
#  - In my experience, unchecking "Reduce Screen Flickering" actually helps the
#    screen not to flicker. Open menu with F1 while playing and set this to what
#    you get the best results with.
#
# Features:
#  
#  - Totally re-written Tilemap and Plane class. Both classes were written to
#    display the map across any screen size automatically. The Tilemap class
#    is probably even more efficient than the original, which will help offset
#    any increased lag due to using a larger screen size with more sprites
#    being displayed.
#  - Every possible autotile graphic (48 per autotile) will be cached for the
#    next time that tile is used.
#  - Autotile animation has been made as efficient as possible, with a system
#    that stores their coodinates, but only if they change. This greatly reduces
#    the number of iterations at each update.
#  - System creates an external file to save pre-cached data priorities and
#    autotiles. This will decrease any loading times even more, and only takes a
#    second, depending on the number of maps you have.
#  - User defined autotile animation speed. Can change with script calls.
#  - Automatic re-sizing of Bitmaps and Viewports that are 640 x 480 to the 
#    defined resolution, unless explicitely over-ridden in the method call.
#    The graphics themselves will not be resized, but any existing scripts that
#    use the normal screen size will already be configured to display different 
#    sizes of graphics for transitions, battlebacks, pictures, fogs, etc.
#  - Option to have a log file ouput each time the game is ran, which can alert
#    you to possible errors with map sizes, etc.
#
# Issues/Bugs/Possible Bugs:
#
#   - Graphic related scripts and your graphics will need to be customized to
#     fit the new screen size, so this script is not for everyone.
#   - The Z-axis for the Plane class, which is used for Fogs and Panoramas has
#     been altered. It is now multiplied by 1000. This will likely be a minor 
#     issue for most, since this class is very rarely used except for Fogs and
#     Panoramas, which are already far above and below respectfully.
#   - Normal transitions using graphics cannot be used. With the exception of
#     a standard fade, like that used when no graphic is defined will be used.
#     Aside from that, only special transitions from Transition Pack can be
#     used.
#
#  Credits/Thanks:
#    - ForeverZer0, for script.
#    - Creators of the Transition Pack and Screenshot.dll
#    - Selwyn, for base resolution script
#
#===============================================================================
#                             CONFIGURATION
#===============================================================================

SCREEN = [Graphics.width, Graphics.height]
# Define the resolution of the game screen. These values can be anything
# within reason. Centering, viewports, etc. will all be taken care of, but it
# is recommended that you use values divisible by 32 for best results.

UPDATE_COUNT = 16
# Define the number of frames between autotile updates. The lower the number,
# the faster the animations cycle. This can be changed in-game with the
# following script call: $game_map.autotile_speed = SPEED

PRE_CACHE_DATA = true
# The pre-cached file is mandatory for the script to work. As long as this is
# true, the data will be created each time the game is test-played. This is
# not always neccessary, only when maps are altered, so you can disable it to
# help speed up game start-up, and it will use the last created file.

RESOLUTION_LOG = true
# This will create a log in the Game directory each time the game is ran in
# DEBUG mode, which will list possible errors with map sizes, etc. 


#===============================================================================
# ** Integer
#===============================================================================

class Integer

  def gcd(num)
    # Returns the greatest common denominator of self and num.
    min, max = self.abs, num.abs
    while min > 0
      tmp = min
      min = max % min
      max = tmp
    end
    return max
  end

  def lcm(num)
    # Returns the lowest common multiple of self and num.
    return [self, num].include?(0) ? 0 : (self / self.gcd(num) * num).abs
  end

end

#===============================================================================
# ** RPG::Cache
#===============================================================================

module RPG::Cache

  AUTO_INDEX = [

    [27,28,33,34],  [5,28,33,34],  [27,6,33,34],  [5,6,33,34],
    [27,28,33,12],  [5,28,33,12],  [27,6,33,12],  [5,6,33,12],
    [27,28,11,34],  [5,28,11,34],  [27,6,11,34],  [5,6,11,34],
    [27,28,11,12],  [5,28,11,12],  [27,6,11,12],  [5,6,11,12],
    [25,26,31,32],  [25,6,31,32],  [25,26,31,12], [25,6,31,12],
    [15,16,21,22],  [15,16,21,12], [15,16,11,22], [15,16,11,12],
    [29,30,35,36],  [29,30,11,36], [5,30,35,36],  [5,30,11,36],
    [39,40,45,46],  [5,40,45,46],  [39,6,45,46],  [5,6,45,46],
    [25,30,31,36],  [15,16,45,46], [13,14,19,20], [13,14,19,12],
    [17,18,23,24],  [17,18,11,24], [41,42,47,48], [5,42,47,48],
    [37,38,43,44],  [37,6,43,44],  [13,18,19,24], [13,14,43,44],
    [37,42,43,48],  [17,18,47,48], [13,18,43,48], [13,18,43,48]

  ]

  def self.autotile(filename)
    key = "Graphics/Autotiles/#{filename}"
    if !@cache.include?(key) || @cache[key].disposed? 
      # Cache the autotile graphic.
      @cache[key] = (filename == '') ? Bitmap.new(128, 96) : Bitmap.new(key)
      # Cache each configuration of this autotile.
      self.format_autotiles(@cache[key], filename)
    end
    return @cache[key]
  end

  def self.format_autotiles(bitmap, filename)
    # Iterate all 48 combinations using the INDEX, and save copy to cache.
    (0...(bitmap.width / 96)).each {|frame|
      # Iterate for each frame in the autotile. (Only for animated ones)
      template = Bitmap.new(256, 192)
      # Create a bitmap to use as a template for creation.
      (0...6).each {|i| (0...8).each {|j| AUTO_INDEX[8*i+j].each {|number|
        number -= 1
        x, y = 16 * (number % 6), 16 * (number / 6)
        rect = Rect.new(x + (frame * 96), y, 16, 16)
        template.blt(32 * j + x % 32, 32 * i + y % 32, bitmap, rect)
      }
      # Use the above created template to create individual tiles.
      index = 8*i+j
      tile = Bitmap.new(32, 32)
      sx, sy = 32 * (index % 8), 32 * (index / 8)
      rect = Rect.new(sx, sy, 32, 32)
      tile.blt(0, 0, template, rect)
      @cache[[filename, index, frame]] = tile
    }}
    # Dispose the template since it will not be used again.
    template.dispose }
  end

  def self.load_autotile(name, tile_id, frame = 0)
    # Returns the autotile for the current map with TILE_ID and FRAME.
    return @cache[[name, tile_id % 48, frame]]
  end
end

#===============================================================================
# ** Tilemap
#===============================================================================

class Tilemap

  attr_reader   :map_data, :ox, :oy, :viewport
  attr_accessor :tileset, :autotiles, :priorities

  def initialize(viewport)
    # Initialize instance variables to store required data.
    @viewport, @autotiles, @layers, @ox, @oy = viewport, [], [], 0, 0
    # Get priority and autotile data for this tileset from instance of Game_Map.
    @priorities, @animated = $game_map.priorities, $game_map.autotile_data
    # Create a sprite and viewport to use for each priority level.
    (0..5).each {|i|
      @layers[i] = Sprite.new(viewport)
      @layers[i].z = i * 32
    }
  end

  def ox=(ox)
    # Set the origin of the X-axis for all the sprites.
    @ox = ox
    @layers.each {|sprite| sprite.ox = @ox } 
  end

  def oy=(oy)
    # Set the origin of the y-axis for all the sprites.
    @oy = oy
    @layers.each {|sprite| sprite.oy = @oy } 
  end

  def dispose
    # Dispose all of the sprites and viewports.
    @layers.each {|layer| layer.dispose }
  end

  def map_data=(data)
    # Set the map data to an instance variable.
    @map_data = data
    # Clear any sprites' bitmaps if it exists, or create new ones.
    @layers.each_index {|i|
      if @layers[i].bitmap != nil
        # Dispose bitmap and set to nil.
        @layers[i].bitmap = @layers[i].bitmap.dispose
      end
      # Create new bitmap, whose size is the same as the game map.
      @layers[i].bitmap = Bitmap.new($game_map.width*32, $game_map.height*32)
    }
    # Draw bitmaps accordingly.
    refresh
  end

  def refresh    
    # Set the animation data from the file if it exists, or create it now.
    @animated = $game_map.autotile_data
    # Iterate through all map layers, starting with the bottom.
    [0,1,2].each {|z| (0...@map_data.ysize).each {|y| (0...@map_data.xsize).each {|x|
      tile_id = @map_data[x, y, z]
      # Go to the next iteration if no bitmap is defined for this tile.
      if tile_id == 0 # No tile
        next
      elsif tile_id < 384 # Autotile
        name = $game_map.autotile_names[(tile_id / 48) - 1]
        bitmap = RPG::Cache.load_autotile(name, tile_id)
      else # Normal Tile
        bitmap = RPG::Cache.tile($game_map.tileset_name, tile_id, 0) 
      end
      # Determine what the layer to draw tile, based off priority.
      layer = @priorities[tile_id] 
      # Perform a block transfer from the created bitmap to the sprite bitmap.
      @layers[layer].bitmap.blt(x*32, y*32, bitmap, Rect.new(0, 0, 32, 32))
    }}}
  end

  def update
    # Update the sprites.
    if Graphics.frame_count % $game_map.autotile_speed == 0
      # Increase current frame of tile by one, looping by width.
      @animated[0].each_index {|i|
        @animated[2][i] = (@animated[2][i] + 1) % @animated[1][i]
        @animated[3][i].each {|data|
          # Gather data using the stored coordinates from the map data.
          tile_id, x, y = @map_data[data[0], data[1], data[2]], data[0], data[1]
          name, layer = @animated[0][i], @priorities[tile_id]
          # Load the next frame of the autotile and set it to the map.
          bitmap = RPG::Cache.load_autotile(name, tile_id, @animated[2][i])
          @layers[layer].bitmap.blt(x*32, y*32, bitmap, Rect.new(0, 0, 32, 32)) 
        }
      }
    end
  end
end

#===============================================================================
# Game_Map
#===============================================================================

class Game_Map

  attr_reader(:tile_size)
  attr_reader(:autotile_speed)
  attr_reader(:autotile_data)
  attr_reader(:priority_data)

  alias_method(:zer0_load_autotile_data_init, :initialize)
  def initialize
    # Load pre-cached data hashes. They will be referenced during setup.
    file = File.open('Data/PreCacheMapData.rxdata', 'rb')
    @cached_priorities = Marshal.load(file)
    @cached_autotiles = Marshal.load(file)
    file.close
    # Call original method.
    zer0_load_autotile_data_init
    # Store the screen dimensions in tiles to save on calculations later.
    @tile_size = [SCREEN[0], SCREEN[1]].collect {|n| (n / 32.0).ceil }
    @autotile_speed = UPDATE_COUNT
  end

  alias_method(:zer0_map_edge_setup, :setup)
  def setup(map_id)
    @priority_data = @cached_priorities[map_id]
    @autotile_data = @cached_autotiles[map_id]
    # Call original method.
    zer0_map_edge_setup(map_id)
    # Find the displayed area of the map in tiles. No calcualting every step.
    @map_edge = [self.width - @tile_size[0], self.height - @tile_size[1]]
    @map_edge.collect! {|size| size * 128 }
  end

  def scroll_down(distance)
    # Find point that the map edge meets the screen edge, using custom size.
    @display_y = [@display_y + distance, @map_edge[1]].min
  end

  def scroll_right(distance)
    # Find point that the map edge meets the screen edge, using custom size.
    @display_x = [@display_x + distance, @map_edge[0]].min
  end

  def autotile_speed=(speed)
    # Keep the speed above 0 to prevent the ZeroDivision Error.
    @autotile_speed = speed
    @autotile_speed = 1 if @autotile_speed < 1
  end
end

#===============================================================================
# ** Game_Character
#===============================================================================

class Game_Character

  def screen_z(height = 0)
    if @always_on_top
      # Return high Z value if always on top flag is present.
      return 999
    elsif height != nil && height > 32
      # Iterate through map characters to their positions relative to this one.
      characters = $game_map.events.values
      characters += [$game_player] unless self.is_a?(Game_Player)
      # Find and set any character that is one tile above this one.
      above, z = characters.find {|chr| chr.x == @x && chr.y == @y - 1 }, 0
      if above != nil
        # If found, adjust value by this one's Z, and the other's.
        z = (above.screen_z(48) >= 32 ? 33 : 31)
      end
      # Check for Blizz-ABS and adjust coordinates for the pixel-rate.
      if $BlizzABS
        x = ((@x / $game_system.pixel_rate) / 2.0).to_i
        y = ((@y / $game_system.pixel_rate) / 2.0).to_i
        return $game_map.priority_data[x, y] + z
      else
        return $game_map.priority_data[@x, @y] + z
      end
    end
    return 0
  end
end

#===============================================================================
# ** Game_Player
#===============================================================================

class Game_Player

  CENTER_X = ((SCREEN[0] / 2) - 16) * 4    # Center screen x-coordinate * 4
  CENTER_Y = ((SCREEN[1] / 2) - 16) * 4    # Center screen y-coordinate * 4

  def center(x, y)
    # Recalculate the screen center based on the new resolution.
    max_x = ($game_map.width - $game_map.tile_size[0]) * 128
    max_y = ($game_map.height - $game_map.tile_size[1]) * 128
    $game_map.display_x = [0, [x * 128 - CENTER_X, max_x].min].max
    $game_map.display_y = [0, [y * 128 - CENTER_Y, max_y].min].max
  end
end

=begin
#===============================================================================
# ** Sprite
#===============================================================================

class Sprite

alias_method(:zer0_sprite_resize_init, :initialize)
def initialize(view = nil)
  # Unless viewport is defined, use the new default viewport size.
  view = Viewport.new(0, 0, SCREEN[0], SCREEN[1]) if view == nil
  # Call original method.
  zer0_sprite_resize_init(view)
end
end

#===============================================================================
# ** Viewport
#===============================================================================

class Viewport

alias_method(:zer0_viewport_resize_init, :initialize)
def initialize(x=0, y=0, width=SCREEN[0], height=SCREEN[1], override=false)
  if x.is_a?(Rect)
    # If first argument is a Rectangle, just use it as the argument.
    zer0_viewport_resize_init(x)
  elsif [x, y, width, height] == [0, 0, 640, 480] && !override 
    # Resize fullscreen viewport, unless explicitly overridden.
    zer0_viewport_resize_init(Rect.new(0, 0, SCREEN[0], SCREEN[1]))
  else
    # Call method normally.
    zer0_viewport_resize_init(Rect.new(x, y, width, height))
  end
end

def resize(*args)
  # Resize the viewport. Can call with (X, Y, WIDTH, HEIGHT) or (RECT).
  self.rect = args[0].is_a?(Rect) ? args[0] : Rect.new(*args)
end
end

#===============================================================================
# ** Bitmap
#===============================================================================

class Bitmap

alias_method(:zer0_resolution_resize_init, :initialize)
def initialize(width = 32, height = 32, override = false)
  if width.is_a?(String)
    # Call the filename if the first argument is a String.
    zer0_resolution_resize_init(width)
  elsif [width, height] == [640, 480] && !override
    # Resize fullscreen bitmap unless explicitly overridden.
    zer0_resolution_resize_init(SCREEN[0], SCREEN[1])
  else
    # Call method normally.
    zer0_resolution_resize_init(width, height)
  end
end
end


#===============================================================================
# ** Plane
#===============================================================================

class Plane

def z=(z)
  # Change the Z value of the viewport, not the sprite.
  super(z * 1000)
end

def ox=(ox)
  return if @bitmap == nil
  # Have viewport stay in loop on X-axis.
  super(ox % @bitmap.width)
end

def oy=(oy)
  return if @bitmap == nil
  # Have viewport stay in loop on Y-axis.
  super(oy % @bitmap.height)
end

def bitmap
  # Return the single bitmap, before it was tiled.
  return @bitmap
end

def bitmap=(tile)
  @bitmap = tile
  # Calculate the number of tiles it takes to span screen in both directions.
  xx = 1 + (SCREEN[0].to_f / tile.width).ceil
  yy = 1 + (SCREEN[1].to_f / tile.height).ceil
  # Create appropriately sized bitmap, then tile across it with source image.
  plane = Bitmap.new(@bitmap.width * xx, @bitmap.height * yy)
  (0..xx).each {|x| (0..yy).each {|y|
    plane.blt(x * @bitmap.width, y * @bitmap.height, @bitmap, @bitmap.rect) 
  }}
  # Set the bitmap to the sprite through its super class (Sprite).
  super(plane)
end

# Redefine methods dealing with coordinates (defined in super) to do nothing.
def x; end
def y; end
def x=(x); end
def y=(y); end
end
=end
#===============================================================================
# DEBUG Mode
#===============================================================================

if $DEBUG 
if PRE_CACHE_DATA
  tilesets = load_data('Data/Tilesets.rxdata')
  maps, priority_data, autotile_data = load_data('Data/MapInfos.rxdata'), {}, {}
  maps.each_key {|map_id|
    map = load_data(sprintf("Data/Map%03d.rxdata", map_id))
    data = map.data
    tileset = tilesets[map.tileset_id]
    priorities = tileset.priorities
    autotiles = tileset.autotile_names.collect {|name| RPG::Cache.autotile(name) }
    animated = [[], [], [], []]
    autotiles.each_index {|i|
      width = autotiles[i].width
      next unless width > 96
      parameters = [tileset.autotile_names[i], width / 96, 0, []]
      [0, 1, 2, 3].each {|j| animated[j].push(parameters[j]) }
    }
    [0, 1, 2].each {|z| (0...data.ysize).each {|y| (0...data.xsize).each {|x|
      tile_id = data[x, y, z]
      next if tile_id == 0
      if tile_id < 384
        name = tileset.autotile_names[(tile_id / 48) - 1]
        index = animated[0].index(name)
        next if index == nil
        above = []
        ((z+1)...data.zsize).each {|zz| above.push(data[x, y, zz]) }
        animated[3][index].push([x, y, z]) if above.all? {|id| id == 0 }
      end
    }}}
    table = Table.new(data.xsize, data.ysize)
    (0...table.xsize).each {|x| (0...table.ysize).each {|y|
      above = [0, 1, 2].collect {|z| data[x, y-1, z] }
      above = above.compact.collect {|p| priorities[p] }
      table[x, y] = above.include?(1) ? 32 : 0
    }}
    priority_data[map_id], autotile_data[map_id] = table, animated
  }
  file = File.open('Data/PreCacheMapData.rxdata', 'wb')
  Marshal.dump(priority_data, file)
  Marshal.dump(autotile_data, file)
  file.close
  RPG::Cache.clear
end

if RESOLUTION_LOG
  undersize, mapinfo = [], load_data('Data/MapInfos.rxdata')
  file = File.open('Data/PreCacheMapData.rxdata', 'rb')
  cached_data = Marshal.load(file)
  file.close
  # Create a text file and write the header.
  file = File.open('Resolution Log.txt', 'wb')
  file.write("[RESOLUTION LOG]\r\n\r\n")
  time = Time.now.strftime("%x at %I:%M:%S %p")
  file.write("  Logged on #{time}\r\n\r\n")
  lcm = SCREEN[0].lcm(SCREEN[1]).to_f
  aspect = [(lcm / SCREEN[1]), (lcm / SCREEN[0])].collect {|num| num.round }
  file.write("RESOLUTION:\r\n  #{SCREEN[0].to_i} x #{SCREEN[1].to_i}\r\n")
  file.write("ASPECT RATIO:\r\n  #{aspect[0]}:#{aspect[1]}\r\n")
  file.write("MINIMUM MAP SIZE:\r\n  #{(SCREEN[0] / 32).ceil} x #{(SCREEN[1] / 32).ceil}\r\n\r\n")
  file.write("UNDERSIZED MAPS:\r\n")
  mapinfo.keys.each {|key|
    map = load_data(sprintf("Data/Map%03d.rxdata", key))
    next if map.width*32 >= SCREEN[0] && map.height*32 >= SCREEN[1]
    undersize.push(key)
  }
  unless undersize.empty?
    file.write("The following maps are too small for the defined resolution. They should be adjusted to prevent graphical errors.\r\n\r\n")
    undersize.sort.each {|id| file.write("    MAP[#{id}]:  #{mapinfo[id].name}\r\n") }
    file.write("\r\n")
  else
    file.write('    All maps are sized correctly.')
  end
  file.close
end
end