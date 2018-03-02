from entity import Entity

class Monster(Entity):
  HITMSG = "You hit the monster. The monster takes {damage} damage."
  DIEMSG = "The monster dies"

  def __init__(self, pos, game):
    super(Monster, self).__init__(pos, game, '!')
    self.hp = 10
    self.attack = 2
    self.defence = 2

  def die(self):
    super(Monster, self).die()
    self.game.monsters.remove(self)
