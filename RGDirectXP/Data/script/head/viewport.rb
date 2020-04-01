#===============================================================================
# ** Viewport
#===============================================================================
class Viewport
  attr_accessor :offset_x, :offset_y, :attached_planes
  
  alias zer0_viewport_resize_init initialize
  def initialize(x=0, y=0, width=Graphics.width, height=Graphics.height, override=false)
    # Variables needed for Viewport children (for the Plane rewrite); ignore if
    # your game resolution is not larger than 640x480
    @offset_x = @offset_y = 0
    
    if x.is_a?(Rect)
      # If first argument is a Rectangle, just use it as the argument.
      zer0_viewport_resize_init(x)
    elsif [x, y, width, height] == [0, 0, 640, 480] && !override 
      # Resize fullscreen viewport, unless explicitly overridden.
      zer0_viewport_resize_init(Rect.new(0, 0, Graphics.width, Graphics.height))
    else
      # Call method normally.
      zer0_viewport_resize_init(Rect.new(x, y, width, height))
    end
  end
  
  def resize(*args)
    # Resize the viewport. Can call with (X, Y, WIDTH, HEIGHT) or (RECT).
    if args[0].is_a?(Rect)
      args[0].x += @offset_x
      args[0].y += @offset_y
      self.rect.set(args[0].x, args[0].y, args[0].width, args[0].height)
    else
      args[0] += @offset_x
      args[1] += @offset_y
      self.rect.set(*args)
    end
  end

end