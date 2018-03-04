import dijkstra
from entity import Entity

class Monster(Entity):
  HITMSG = "You hit the monster. The monster takes {damage} damage."
  DIEMSG = "The monster dies"

  def __init__(self, pos, game):
    super(Monster, self).__init__(pos, game, '!')
    self.smell = 10 # Squares from player
    self.hp = 10
    self.attack = 2
    self.defence = 2

  def die(self):
    super(Monster, self).die()
    self.g.monsters.remove(self)

  def have_turn(self):
    seek = self.g.player.seek_map
    y, x = self.pos
    if seek[y,x] <= self.smell:
      self.move(dijkstra.roll_downhill(seek, x, y))
