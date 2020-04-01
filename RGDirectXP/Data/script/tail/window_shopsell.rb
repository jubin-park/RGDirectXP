#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  This window displays items in possession for selling on the shop screen.
#==============================================================================

class Window_ShopSell < Window_Selectable
  def refresh

    ## fix crash
    if !self.contents.disposed?
      self.contents.dispose
    end
    ## old code
    #if self.contents != nil
    #  self.contents.dispose
    #  self.contents = nil
    #end

    @data = []
    for i in 1...$data_items.size
      if $game_party.item_number(i) > 0
        @data.push($data_items[i])
      end
    end
    for i in 1...$data_weapons.size
      if $game_party.weapon_number(i) > 0
        @data.push($data_weapons[i])
      end
    end
    for i in 1...$data_armors.size
      if $game_party.armor_number(i) > 0
        @data.push($data_armors[i])
      end
    end
    # If item count is not 0, make a bitmap and draw all items
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
end