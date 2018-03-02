import tdl
import numpy as np
from map import Map
from functools import partial
from numpy import array
from player import Player
from monster import Monster

LEVEL = """
      ########
      #......#
#######......######
#........@........#     ############
#.#####......####.#     #..........#
#.#   #......#  #.#     #..........#
#.#   ########  #.#     #..........#
#.#             #.#     #..........#
#.#       #######.#######..........#
#.#       #........................#
#.#       #.#############..........#
#.#########.#           #..........#
#...........#           #..........#
#############           #..........#
                        #..........#
                        #..........#
                        ############
"""[1:-1]

def const(v=None): return lambda *_: v

class Game:
  def __init__(self):
    self.m = Map(LEVEL)

    self.monsters = []
    for p, ch in self.m.special:
      if ch == '@':
        self.player = Player(p, self.m)
      elif ch == '!':
        self.monsters.append(Monster(p, self.m))
    
    self.m.entities.append(self.player)
    self.m.entities.extend(self.monsters)

    tdl.set_font("arial12x12.png", greyscale=True, altLayout=True)
    self.c = tdl.init(self.m.width, self.m.height, 'title')
    self.finish = False

  def draw(self):
    self.c.clear()
    self.m.draw(self.c)
    tdl.flush()

  def handle_events(self):
    for ev in tdl.event.get():
      self.EH.get(ev.type, const())(self, ev)

  def have_turn(self):
    if not self.player.have_turn(): return
    for monster in self.monsters:
      monster.have_turn()

  def run(self):
    while not (tdl.event.is_window_closed() or self.finish):
      self.draw()
      self.handle_events()
      self.have_turn()

  def quit(self):
    self.finish = True

  def key_down(self, ev):
    return self.KEYS.get(ev.keychar, const())(self)

  def move(v, self):
    self.player.action("move_attack", v)

  KEYS = {
    "ESCAPE": quit,
    "q": quit,

    "h": partial(move, (-1, 0)),
    "j": partial(move, (0, 1)),
    "k": partial(move, (0, -1)),
    "l": partial(move, (1, 0)),
    "y": partial(move, (-1, -1)),
    "u": partial(move, (1, -1)),
    "b": partial(move, (-1, 1)),
    "n": partial(move, (1, 1)),
  }

  EH = {
    "KEYDOWN": key_down,
  }

def main():
  Game().run()
