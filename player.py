from entity import Entity
import dijkstra

class Player(Entity):
  HITMSG = "The monster hits you. You take {damage} damage."
  DIEMSG = "You die"

  def __init__(self, pos, m):
    super(Player, self).__init__(pos, m, '@')
    self.seek_map = dijkstra.init(self.m.shape)
    self.recalculate_dijkstra()
    self.light_radius = 4

    # Stats
    self.hp = 10
    self.attack = 5
    self.defence = 2

  def recalculate_dijkstra(self):
    dijkstra.clear(self.seek_map, (self.pos,))
    dijkstra.calculate(self.seek_map, self.m.walkable_points)

  def move(self, v):
    ret = super(Player, self).move(v)
    if ret:
      self.recalculate_dijkstra()
    return ret

  def die(self):
    super(Player, self).die()
    self.g.quit()
