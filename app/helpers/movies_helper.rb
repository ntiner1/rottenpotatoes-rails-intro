module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def clickedCss(type)
    if type == @clicked
      return 'hilite'
    end
  end
end
