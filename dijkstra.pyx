import numpy as np
cimport numpy as np

cdef int min_neighbour(m, np.ndarray[np.int_t, ndim=2] d, np.ndarray[np.int_t] p) except *:
  cdef tuple pos = (p[0], p[1])
  cdef np.ndarray[np.int_t, ndim=2] pts, valid
  pts = m.neighbours[pos]
  valid = pts[
    np.nonzero(
      np.logical_and(
        np.greater_equal(pts, [0, 0]).all(1),
        np.less(pts, m.shape).all(1)
      )
    )
  ]
  cdef tuple idx = tuple(np.transpose(valid))
  return min(d[idx])

def calculate_dijkstra(np.ndarray[np.int_t, ndim=2] d, m):
  cdef np.ndarray[np.int_t] p
  npd = np.array(d)
  cdef bint changed = True
  while changed:
    changed = False
    for p in m.walkable_points:
      new = min_neighbour(m, d, p)
      if d[p[0],p[1]] > new:
        d[p[0],p[1]] = new
        changed = True

def clear_dijkstra(np.int_t[:,:] d, targets=()):
  cdef int v, x, y
  d[:] = d.shape[0] * d.shape[1]
  for target in targets:
    v = 0
    if len(target) > 2:
      target, v = target
    y, x = target
    d[y, x] = v

def init_dijkstra(np.int_t[:] shape):
  return np.empty(shape, int)
