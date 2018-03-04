import numpy as np
cimport numpy as np

cdef inline int min_neighbour(np.int_t[:,:] d, Py_ssize_t[:] shape, int sx, int sy) except -1:
  cdef int r = shape[0] * shape[1] + 2
  for y in range(sy - 1, sy + 2):
    for x in range(sx - 1, sx + 2):
      if not (y == sy and x == sx) \
          and 0 <= y < shape[0] \
          and 0 <= x < shape[1] \
          and d[y,x] < r:
        r = d[y,x]
  if r == shape[0] * shape[1] + 2:
    raise ValueError("No valid neighbours for point (%d, %d)" % (sx, sy))
  return r

def calculate(np.int_t[:,:] d, np.int_t[:,:] wp):
  cdef Py_ssize_t[:] shape = d.shape
  cdef int new, x, y
  cdef bint changed = True
  while changed:
    changed = False
    for y, x in wp:
      new = min_neighbour(d, shape, x, y) + 1
      if d[y,x] > new:
        d[y,x] = new
        changed = True

def clear(np.int_t[:,:] d, targets=()):
  cdef int v
  cdef size_t x, y
  d[:] = d.size + 1
  for target in targets:
    v = 0
    if len(target) > 2:
      target, v = target
    y, x = target
    d[y, x] = v

def init(np.int_t[:] shape):
  return np.empty(shape, int)

def draw_light(np.ndarray[np.int_t, ndim=2] d, g, int radius):
  cdef unsigned char b, v = 255 / (radius + 1)
  for p, x in np.ndenumerate(d):
    if x > radius: b = 0
    else: b = 255 - v * x
    g.setcolour(p, (b, b, b))

# For debugging
def draw_map(np.ndarray[np.int_t, ndim=2] d, g):
  cdef unsigned char b
  for p, n in np.ndenumerate(d):
    b = max(200 - (20 * n), 0)
    g.putc(p, str(n)[-1], (b, b, b))
