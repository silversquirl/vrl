import numpy as np
from util import in_bounds

class Entity:
  HITMSG = "Something takes {damage} damage."
  DIEMSG = "Something dies."

  def __init__(self, pos, game, ch, colour=0xFFFFFF):
    self.pos = np.array(pos)
    self.m = game.m
    self.g = game
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
    self.g.messages.append(self.DIEMSG)

  def hit(self, attacker):
    damage = attacker.attack // max(self.defence, 1)
    self.hp -= damage
    self.g.messages.append(self.HITMSG.format(damage=damage))
    if self.hp <= 0:
      self.die()
    return damage

  def move(self, v, attack=True):
    "Move the entity in the direction of the row-major vector v"
    v = np.clip(v, -1, 1)
    pos = (self.pos + v)

    if not in_bounds(pos, self.m.shape):
      return False
    if not self.m.walkable[tuple(pos)]:
      return False

    target = self.m.collide(pos)
    if target:
      target.hit(self)
      return True

    self.pos = pos
    return True

  def draw(self, g):
    g.putc(self.pos, self.ch, fg=self.colour)
