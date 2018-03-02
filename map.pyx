import numpy as np
cimport numpy as np
import util

cdef class Map:
  cdef np.uint8_t[:,:] walk, trans
  cdef np.int_t[:,:] walk_pts, chars
  cdef np.int_t[:,:,:,:] neigh
  cdef public list entities, special

  def __init__(self, level):
    level = level.split('\n')
    self.chars = np.empty((len(level), max(map(len, level))), int)
    self.chars[:] = ord(' ')

    self.special = []
    cdef int y, x
    for y, line in enumerate(level):
      for x, ch in enumerate(line):
        if ch in '@!':
          self.special.append(((y, x), ch))
          ch = '.'
        self.chars[y,x] = ord(ch)

    self.walk = np.uint8(np.equal(self.chars, ord('.')))
    self.trans = np.uint8(np.not_equal(self.chars, ord('#')))

    self.neigh = util.neighbours(tuple(self.shape))
    self.walk_pts = np.transpose(np.nonzero(self.walk))

    self.entities = []

  @property
  def walkable(self): return np.array(self.walk)
  @property
  def transparent(self): return np.array(self.trans)
  @property
  def neighbours(self): return np.array(self.neigh)
  @property
  def walkable_points(self): return np.array(self.walk_pts)

  @property
  def shape(self):
    return np.array([self.chars.shape[0], self.chars.shape[1]])
  @property
  def width(self): return self.shape[1]
  @property
  def height(self): return self.shape[0]

  def draw(self, c):
    for p, ch in np.ndenumerate(self.chars):
      c.draw_char(p[1], p[0], ch)
    for e in self.entities:
      e.draw(c)
