import numpy as np
cimport numpy as np

ctypedef np.int_t[:] a1d
ctypedef np.int_t[:,:] a2d

cpdef bint in_bounds(a1d p, a1d shape):
  "Checks if the vector p is a valid index in the rectangle between (0, 0) and shape"
  return np.greater_equal(p, [0, 0]).all() and np.less(p, shape).all()

cpdef np.int_t[:,:,:,:] neighbours(tuple shape):
  """Calculate an array with neighbours for each integer coordinate in the rectangle between (0, 0) and shape.
Calculated values may or may not be valid indices for a. Checking with in_bounds is recommended."""
  cdef a2d idx, u, d, l, r, ul, dr, ur, dl
  idx = np.indices((shape[0], shape[1])).T.reshape(shape[0] * shape[1], 2)

  # Cardinal directions
  u = np.add(idx, [-1, -0])
  d = np.add(idx, [1, 0])
  l = np.add(idx, [-0, -1])
  r = np.add(idx, [0, 1])

  # Diagonals
  ul = np.add(idx, [-1, -1])
  dr = np.add(idx, [1, 1])
  ur = np.add(idx, [-1, 1])
  dl = np.add(idx, [1, -1])

  return np.transpose([u, d, l, r, ul, dr, ur, dl], (1, 0, 2)) \
           .reshape((shape[0], shape[1], -1, 2))
