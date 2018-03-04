import numpy as np
from util import in_bounds

class Entity:
  HITMSG = "Something took {damage} damage."
  DIEMSG = "Something died."

  def __init__(self, pos, m, ch, colour=0xFFFFFF):
    self.pos = np.array(pos)
    self.m = m
    self.ch = ch
    self.colour = colour

    # Stats
    self.hp = 1
    self.attack = 0
    self.defence = 0

  @property
  def x(self): return self.pos[1]
  @property
  def y(self): return self.pos[0]

  def die(self):
    self.m.messages.append(self.DIEMSG)

  def hit(self, attacker):
    damage = attacker.attack // max(self.defence, 1)
    self.hp -= damage
    self.m.messages.append(self.HITMSG.format(damage=damage))
    if self.hp <= 0:
      self.die()
    return damage

  def move(self, v):
    v = np.clip(np.array(v)[::-1], -1, 1)
    pos = (self.pos + v)
    if not in_bounds(pos, self.m.shape):
      return False, None
    if not self.m.walkable[tuple(pos)]:
      return False, pos
    self.pos = pos
    return True, pos

  def move_or_attack(self, v):
    succ, pos = self.move(v)
    if succ:
      return True
    # TODO: Implement attacking
    return False

  def draw(self, g):
    g.putc(self.pos, self.ch, fg=self.colour)
