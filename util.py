def in_bounds(p, shape):
  "Check if the vector p is a valid index in the rectangle between (0, 0) and shape"
  return 0 <= p[0] < shape[0] and 0 <= p[1] < shape[1]
