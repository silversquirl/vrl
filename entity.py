import numpy as np
from collections import deque
from action import *
from util import in_bounds

class Entity:
  HITMSG = "Something took {damage} damage."
  DIEMSG = "Something died."

  def __init__(self, pos, m, ch):
    self.pos = np.array(pos)
    self.m = m
    self.ch = ch
    self.aq = deque() # Action queue

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

  def draw(self, c):
    c.draw_char(self.x, self.y, self.ch, fg=0xFFFFFF)

  def action(self, action, *args):
    "Push an Action to the action queue"
    if isinstance(action, str):
      action = {
        "move_attack": MoveOrAttackAction,
      }[action.lower()](*args)
    self.aq.append(action)

  def pop_apply_action(self):
    "Pop and apply an action from the action queue"
    if len(self.aq) == 0:
      return False
    return self.aq.popleft().apply(self)

  def have_turn(self):
    return self.pop_apply_action()
