import numpy as np

class Map:
  def __init__(self, level):
    level = level.split('\n')
    self.chars = np.empty((len(level), max(map(len, level))), int)
    self.chars[:] = ord(' ')

    self.special = []
    for y, line in enumerate(level):
      for x, ch in enumerate(line):
        if ch in '@!':
          self.special.append(((y, x), ch))
          ch = '.'
        self.chars[y,x] = ord(ch)

    self.walkable = self.chars == ord('.')
    self.transparent = self.chars != ord('#')

    self.walkable_points = np.transpose(self.walkable.nonzero())

    self.entities = []

  @property
  def shape(self):
    return np.array(self.chars.shape)
  @property
  def width(self): return self.shape[1]
  @property
  def height(self): return self.shape[0]

  def draw(self, g):
    for p, ch in np.ndenumerate(self.chars):
      g[p] = ch
    for e in self.entities:
      e.draw(g)
