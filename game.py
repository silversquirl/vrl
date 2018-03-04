import tcod.console
import dijkstra
from map import Map
from functools import partial
from player import Player
from monster import Monster

LEVEL = """
      ########
      #......#
#######......######
#........@........#       ########
#.#####......####.#       #......#
#.#   #......#  #.#       #......#
#.#   ########  #.#       #......#
#.########      #.#       ###.####
#.##.....########.###########.######
#.##.....##........................#
#.##.....##.###.##################.#
#.####.####.# #.#       #######  #.#
#...........# #.#       #.....####.#
############# #.#       #..........#
              #.#       #.....######
              #.###########.###
              #.............#
              #.#############
              #.#
              #.#
              #.#
        #######.#######
        #.............#
        #.............#
        #.............#
        #.............#
        #.............#
        #.............#
        #.............#
        #.............#
        ###############
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

    tcod.console.set_font("arial12x12.png", tcod.console.FONT_LAYOUT_TCOD | tcod.console.FONT_TYPE_GREYSCALE)
    self.c = tcod.console.init_root(self.m.width, self.m.height, 'vrl')
    self.finish = False

  def __setitem__(self, pos, ch):
    self.putc(pos, ch)

  def putc(self, pos, ch, fg=None, bg=None):
    y, x = pos
    if isinstance(ch, str):
      ch = ord(ch)

    if fg and bg:
      tcod.console.put_char_ex(self.c, x, y, ch, fg, bg)
    else:
      tcod.console.put_char(self.c, x, y, ch)
      if fg:
        tcod.console.set_foreground(self.c, x, y, fg)
      elif bg:
        tcod.console.set_background(self.c, x, y, bg)

  def setcolour(self, pos, fg=None, bg=None):
    y, x = pos
    if fg: tcod.console.set_foreground(self.c, x, y, fg)
    if bg: tcod.console.set_background(self.c, x, y, bg)

  def draw(self):
    tcod.console.clear(self.c)
    self.m.draw(self)
    dijkstra.draw_light(self.player.seek_map, self, self.player.light_radius)
    #dijkstra.draw_map(self.player.seek_map, self)
    tcod.console.flush()

  def handle_events(self):
    while not (tcod.console.is_window_closed() or self.finish):
      k = tcod.console.wait_for_keypress(True)
      if k['pressed']:
        if self.key_down(k):
          return True

  def run(self):
    self.draw()
    while self.handle_events():
      self.draw()

  def quit(self):
    self.finish = True
    return True

  def key_down(self, k):
    return self.KEYS.get(chr(k['c']), const())(self)

  def move(v, self):
    return self.player.move_or_attack(v)

  KEYS = {
    #"ESCAPE": quit, # FIXME: not currently working. This is an issue with my libTCOD wrapper
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

def main():
  Game().run()
