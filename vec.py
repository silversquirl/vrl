from functools import singledispatch

def _V(o, *args):
  return Vector.__new__(type(o), *args)

class Vector(tuple):
  def __new__(cls, vec, y=None):
    if y is not None:
      vec = vec, y
    vec = map(Scalar, vec)
    return tuple.__new__(cls, vec)

  def __add__(self, other):
    return _V(self, self.x + other[0], self.y + other[1])

  def __sub__(self, other):
    return self + (-other[0], -other[1])

  def __neg__(self):
    return _V(self, -self.x, -self.y)

  @property
  def x(self): return self[0]
  @property
  def y(self): return self[1]

  def limit(self, lower, upper):
    return _V(self, self.x.limit(lower[0], upper[0]), self.y.limit(lower[1], upper[1]))

  def between(self, lower, upper):
    return self.x.between(lower[0], upper[0]) and self.y.between(lower[1], upper[1])

def _S(o, *args):
  return Scalar.__new__(type(o), *args)

class Scalar(int):
  def limit(self, lower, upper):
    if lower > upper:
      lower, upper = upper, lower

    if self < lower:
      return _S(self, lower)
    elif self > upper:
      return _S(self, upper)
    return self

  def between(self, lower, upper):
    if lower > upper:
      lower, upper = upper, lower
    return lower <= self <= upper
