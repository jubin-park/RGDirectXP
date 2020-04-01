=begin
================================================================================
 Ruby 1.8 Methods
 Author: N/A
 Version: 1.2
--------------------------------------------------------------------------------
 [ Description ]
 Contains methods for existing classes that may have not made its transition
 over to Ruby 1.9 (RGSS3).
 This list is on-going as people report them.

 [ Instructions ]
 There is nothing to do here.
 Please keep this script in its current location.

________________________________________________________________________________

 [ Version History]
 
 Ver.      Date            Notes
 -----     -----------     -----------------------------------------------------
 1.2       17 Apr 2018     - Added:
                             + XP's Input module (constants return ints, not symbols)
 1.1       26 Mar 2017     - Added:
                             + Array#to_s
                             + String#delete/delete!
                             + String#[]
 1.0       28 Feb 2016     - First implemented
================================================================================
=end

$DEBUG = $TEST

# Object - p
def p(*args)
  msgbox_p(*args)
end

# Object - print
def print(*args)
  msgbox(*args)
end

# Array - nitems, to_s
unless Array.method_defined?(:nitems)  
  class Array    
    def nitems      
      count{|x| !x.nil?}    
    end
    
    # In Ruby 1.9, the returned string would include the square brackets [].
    # Ruby 1.8 does not.
    def to_s
      self.join('')
    end
  end
end

# String - delete, delete!, []
class String
  
  # Ruby 1.9 encodes strings to UTF-8 rather than treats them as pure bytes in 
  # Ruby 1.8. This causes errors in scripts that attempt to delete null 
  # characters ("\0"). This fix converts any of those invalid byte-sequences to
  # something acceptable then removes them.
  alias delete_utf8 delete
  def delete(arg)
    s = self.encode("UTF-16be", :invalid=>:replace, :replace=>"\uFFFD").encode('UTF-8')
    s.delete_utf8(arg + "\uFFFD")
  end
  
  alias delete_self_utf8 delete!
  def delete!(arg)
    self.encode!("UTF-16be", :invalid=>:replace, :replace=>"\uFFFD").encode!('UTF-8')
    delete_self_utf8(arg + "\uFFFD")
  end

  # In Ruby 1.8, if only one argument is passed, it would return the character
  # byte at that index rather than the character itself (which Ruby 1.9 does).
  alias getchar []
  def [](*args)
    if args.size == 1 && args[0].is_a?(Fixnum)
      self.getbyte(args[0])
    else
      getchar(*args)
    end
  end
end

# The constants listed below return Symbols in VXA, but integers in XP. This
# changes it to XP's standards, but you can still use symbols.

# i.e. Input.trigger?(Input::C) and Input.trigger?(:C) both work.

# This was done for any potential scripts that assumed these constants
# returned a number.
module Input
  DOWN = 2
  LEFT = 4
  RIGHT = 6
  UP = 8
  A = 11
  B = 12
  C = 13
  X = 14
  Y = 15
  Z = 16
  L = 17
  R = 18
  SHIFT = 21
  CTRL = 22
  ALT = 23
  F5 = 25
  F6 = 26
  F7 = 27
  F8 = 28
  F9 = 29
end