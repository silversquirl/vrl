from entity import Entity
from dijkstra import *

class Player(Entity):
  HITMSG = "The monster hits you. You take {damage} damage."
  DIEMSG = "You die"

  def __init__(self, pos, m):
    super(Player, self).__init__(pos, m, '@')
    self.seek_map = init_dijkstra(self.m.shape)
    self.recalculate_dijkstra()

    # Stats
    self.hp = 10
    self.attack = 5
    self.defence = 2

  def recalculate_dijkstra(self):
    clear_dijkstra(self.seek_map, (self.pos,))
    calculate_dijkstra(self.seek_map, self.m)

  def move(self, v):
    ret = super(Player, self).move(v)
    self.recalculate_dijkstra()
    return ret

  def die(self):
    super(Player, self).die()
    self.level.end()
