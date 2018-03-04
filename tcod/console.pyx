# distutils: libraries = tcod

# --- Header ---
cdef extern from "libtcod/libtcod.h":
  ctypedef void *TCOD_console_t

  ctypedef enum TCOD_renderer_t:
    TCOD_RENDERER_GLSL
    TCOD_RENDERER_OPENGL
    TCOD_RENDERER_SDL
    TCOD_NB_RENDERERS

  ctypedef enum TCOD_font_flags_t:
    TCOD_FONT_LAYOUT_ASCII_INCOL=1
    TCOD_FONT_LAYOUT_ASCII_INROW=2
    TCOD_FONT_TYPE_GREYSCALE=4
    TCOD_FONT_TYPE_GRAYSCALE=4
    TCOD_FONT_LAYOUT_TCOD=8

  ctypedef enum TCOD_keycode_t:
    TCODK_NONE
    TCODK_ESCAPE
    TCODK_BACKSPACE
    TCODK_TAB
    TCODK_ENTER
    TCODK_SHIFT
    TCODK_CONTROL
    TCODK_ALT
    TCODK_PAUSE
    TCODK_CAPSLOCK
    TCODK_PAGEUP
    TCODK_PAGEDOWN
    TCODK_END
    TCODK_HOME
    TCODK_UP
    TCODK_LEFT
    TCODK_RIGHT
    TCODK_DOWN
    TCODK_PRINTSCREEN
    TCODK_INSERT
    TCODK_DELETE
    TCODK_LWIN
    TCODK_RWIN
    TCODK_APPS
    TCODK_0
    TCODK_1
    TCODK_2
    TCODK_3
    TCODK_4
    TCODK_5
    TCODK_6
    TCODK_7
    TCODK_8
    TCODK_9
    TCODK_KP0
    TCODK_KP1
    TCODK_KP2
    TCODK_KP3
    TCODK_KP4
    TCODK_KP5
    TCODK_KP6
    TCODK_KP7
    TCODK_KP8
    TCODK_KP9
    TCODK_KPADD
    TCODK_KPSUB
    TCODK_KPDIV
    TCODK_KPMUL
    TCODK_KPDEC
    TCODK_KPENTER
    TCODK_F1
    TCODK_F2
    TCODK_F3
    TCODK_F4
    TCODK_F5
    TCODK_F6
    TCODK_F7
    TCODK_F8
    TCODK_F9
    TCODK_F10
    TCODK_F11
    TCODK_F12
    TCODK_NUMLOCK
    TCODK_SCROLLLOCK
    TCODK_SPACE
    TCODK_CHAR
    TCODK_TEXT

  ctypedef struct TCOD_key_t:
    TCOD_keycode_t vk
    unsigned char c
    char *text
    bint pressed
    bint lalt, ralt, lctrl, rctrl, lmeta, rmeta, shift

  ctypedef enum TCOD_bkgnd_flag_t:
    TCOD_BKGND_NONE
    TCOD_BKGND_SET
    TCOD_BKGND_MULTIPLY
    TCOD_BKGND_LIGHTEN
    TCOD_BKGND_DARKEN
    TCOD_BKGND_SCREEN
    TCOD_BKGND_COLOR_DODGE
    TCOD_BKGND_COLOR_BURN
    TCOD_BKGND_ADD
    TCOD_BKGND_ADDA
    TCOD_BKGND_BURN
    TCOD_BKGND_OVERLAY
    TCOD_BKGND_ALPH
    TCOD_BKGND_DEFAULT
  TCOD_bkgnd_flag_t TCOD_BKGND_ALPHA(int alpha)
  TCOD_bkgnd_flag_t TCOD_BKGND_ADDALPHA(int alpha)

  ctypedef struct TCOD_color_t:
    unsigned char r, g, b

  void TCOD_console_init_root(int w, int h, const char *title, bint fullscreen, TCOD_renderer_t renderer)
  void TCOD_console_set_custom_font(const char *filename, TCOD_font_flags_t flags, int w, int h)

  bint TCOD_console_is_window_closed()
  TCOD_key_t TCOD_console_wait_for_keypress(bint flush)

  void TCOD_console_flush()
  void TCOD_console_clear(TCOD_console_t con)
  void TCOD_console_set_char_background(TCOD_console_t con, int x, int y, TCOD_color_t bg, TCOD_bkgnd_flag_t flag)
  void TCOD_console_set_char_foreground(TCOD_console_t con, int x, int y, TCOD_color_t fg)
  void TCOD_console_set_char(TCOD_console_t con, int x, int y, int ch)
  void TCOD_console_put_char(TCOD_console_t con, int x, int y, int ch, TCOD_bkgnd_flag_t flag)
  void TCOD_console_put_char_ex(TCOD_console_t con, int x, int y, int ch, TCOD_color_t fg, TCOD_color_t bg)

# --- Python type wrappers ---
cdef class Console:
  cdef TCOD_console_t con

cdef class Key:
  cdef TCOD_key_t key

  @property
  def pressed(self):
    return self.key.pressed

  @property
  def text(self):
    return self.key.vk == TCODK_TEXT

  @property
  def kind(self):
    if self.key.vk == TCODK_TEXT:
      return "text"
    else:
      return "key"

  @property
  def modifiers(self):
    mods = set()
    if self.key.lalt or self.key.ralt:
      mods.add("alt")
    if self.key.lctrl or self.key.rctrl:
      mods.add("ctrl")
    if self.key.lmeta or self.key.rmeta:
      mods.add("meta")
    if self.key.shift:
      mods.add("shift")
    return mods

  @property
  def key(self):
    if self.key.vk == TCODK_NONE:
      return None
    elif self.key.vk == TCODK_ESCAPE:
      return "ESCAPE"
    elif self.key.vk == TCODK_BACKSPACE:
      return "BACKSPACE"
    elif self.key.vk == TCODK_TAB:
      return "TAB"
    elif self.key.vk == TCODK_ENTER:
      return "ENTER"
    elif self.key.vk == TCODK_SHIFT:
      return "SHIFT"
    elif self.key.vk == TCODK_CONTROL:
      return "CONTROL"
    elif self.key.vk == TCODK_ALT:
      return "ALT"
    elif self.key.vk == TCODK_PAUSE:
      return "PAUSE"
    elif self.key.vk == TCODK_CAPSLOCK:
      return "CAPSLOCK"
    elif self.key.vk == TCODK_PAGEUP:
      return "PAGEUP"
    elif self.key.vk == TCODK_PAGEDOWN:
      return "PAGEDOWN"
    elif self.key.vk == TCODK_END:
      return "END"
    elif self.key.vk == TCODK_HOME:
      return "HOME"
    elif self.key.vk == TCODK_UP:
      return "UP"
    elif self.key.vk == TCODK_LEFT:
      return "LEFT"
    elif self.key.vk == TCODK_RIGHT:
      return "RIGHT"
    elif self.key.vk == TCODK_DOWN:
      return "DOWN"
    elif self.key.vk == TCODK_PRINTSCREEN:
      return "PRINTSCREEN"
    elif self.key.vk == TCODK_INSERT:
      return "INSERT"
    elif self.key.vk == TCODK_DELETE:
      return "DELETE"
    elif self.key.vk == TCODK_LWIN:
      return "LWIN"
    elif self.key.vk == TCODK_RWIN:
      return "RWIN"
    elif self.key.vk == TCODK_APPS:
      return "APPS"
    elif self.key.vk == TCODK_0:
      return "0"
    elif self.key.vk == TCODK_1:
      return "1"
    elif self.key.vk == TCODK_2:
      return "2"
    elif self.key.vk == TCODK_3:
      return "3"
    elif self.key.vk == TCODK_4:
      return "4"
    elif self.key.vk == TCODK_5:
      return "5"
    elif self.key.vk == TCODK_6:
      return "6"
    elif self.key.vk == TCODK_7:
      return "7"
    elif self.key.vk == TCODK_8:
      return "8"
    elif self.key.vk == TCODK_9:
      return "9"
    elif self.key.vk == TCODK_KP0:
      return "KP0"
    elif self.key.vk == TCODK_KP1:
      return "KP1"
    elif self.key.vk == TCODK_KP2:
      return "KP2"
    elif self.key.vk == TCODK_KP3:
      return "KP3"
    elif self.key.vk == TCODK_KP4:
      return "KP4"
    elif self.key.vk == TCODK_KP5:
      return "KP5"
    elif self.key.vk == TCODK_KP6:
      return "KP6"
    elif self.key.vk == TCODK_KP7:
      return "KP7"
    elif self.key.vk == TCODK_KP8:
      return "KP8"
    elif self.key.vk == TCODK_KP9:
      return "KP9"
    elif self.key.vk == TCODK_KPADD:
      return "KPADD"
    elif self.key.vk == TCODK_KPSUB:
      return "KPSUB"
    elif self.key.vk == TCODK_KPDIV:
      return "KPDIV"
    elif self.key.vk == TCODK_KPMUL:
      return "KPMUL"
    elif self.key.vk == TCODK_KPDEC:
      return "KPDEC"
    elif self.key.vk == TCODK_KPENTER:
      return "KPENTER"
    elif self.key.vk == TCODK_F1:
      return "F1"
    elif self.key.vk == TCODK_F2:
      return "F2"
    elif self.key.vk == TCODK_F3:
      return "F3"
    elif self.key.vk == TCODK_F4:
      return "F4"
    elif self.key.vk == TCODK_F5:
      return "F5"
    elif self.key.vk == TCODK_F6:
      return "F6"
    elif self.key.vk == TCODK_F7:
      return "F7"
    elif self.key.vk == TCODK_F8:
      return "F8"
    elif self.key.vk == TCODK_F9:
      return "F9"
    elif self.key.vk == TCODK_F10:
      return "F10"
    elif self.key.vk == TCODK_F11:
      return "F11"
    elif self.key.vk == TCODK_F12:
      return "F12"
    elif self.key.vk == TCODK_NUMLOCK:
      return "NUMLOCK"
    elif self.key.vk == TCODK_SCROLLLOCK:
      return "SCROLLLOCK"
    elif self.key.vk == TCODK_SPACE:
      return "SPACE"
    elif self.key.vk == TCODK_CHAR or self.key.vk == TCODK_TEXT:
      return chr(self.key.c)
    elif self.key.vk == TCODK_TEXT:
      return self.key.text.decode('utf-8')
    else:
      raise ValueError("Unknown key")

# --- Python enum wrappers ---
RENDERER_GLSL   = TCOD_RENDERER_GLSL
RENDERER_OPENGL = TCOD_RENDERER_OPENGL
RENDERER_SDL    = TCOD_RENDERER_SDL
NB_RENDERERS    = TCOD_NB_RENDERERS

FONT_LAYOUT_ASCII_INCOL = TCOD_FONT_LAYOUT_ASCII_INCOL
FONT_LAYOUT_ASCII_INROW = TCOD_FONT_LAYOUT_ASCII_INROW
FONT_TYPE_GREYSCALE     = TCOD_FONT_TYPE_GREYSCALE
FONT_TYPE_GRAYSCALE     = TCOD_FONT_TYPE_GRAYSCALE
FONT_LAYOUT_TCOD        = TCOD_FONT_LAYOUT_TCOD

BKGND_NONE        = TCOD_BKGND_NONE
BKGND_SET         = TCOD_BKGND_SET
BKGND_MULTIPLY    = TCOD_BKGND_MULTIPLY
BKGND_LIGHTEN     = TCOD_BKGND_LIGHTEN
BKGND_DARKEN      = TCOD_BKGND_DARKEN
BKGND_SCREEN      = TCOD_BKGND_SCREEN
BKGND_COLOR_DODGE = TCOD_BKGND_COLOR_DODGE
BKGND_COLOR_BURN  = TCOD_BKGND_COLOR_BURN
BKGND_ADD         = TCOD_BKGND_ADD
BKGND_ADDA        = TCOD_BKGND_ADDA
BKGND_BURN        = TCOD_BKGND_BURN
BKGND_OVERLAY     = TCOD_BKGND_OVERLAY
BKGND_ALPH        = TCOD_BKGND_ALPH
BKGND_DEFAULT     = TCOD_BKGND_DEFAULT

def BKGND_ALPHA(int alpha):
  return TCOD_BKGND_ALPHA(alpha)
def BKGND_ADDALPHA(int alpha):
  return TCOD_BKGND_ADDALPHA(alpha)

# --- Init ---
def set_font(str filename, TCOD_font_flags_t flags):
  TCOD_console_set_custom_font(filename.encode('utf-8'), flags, 0, 0)

def init_root(int w, int h, str title, bint fullscreen=False, TCOD_renderer_t renderer=TCOD_RENDERER_SDL):
  TCOD_console_init_root(w, h, title.encode('utf-8'), fullscreen, renderer)
  root = Console()
  root.con = NULL
  return root

# --- Events ---
def is_window_closed():
  return TCOD_console_is_window_closed()

def wait_for_keypress(bint flush=False):
  k = Key()
  k.key = TCOD_console_wait_for_keypress(flush)
  return k

# --- Drawing ---
def flush():
  TCOD_console_flush()

def clear(Console con not None):
  TCOD_console_clear(con.con)

def set_background(Console con not None, int x, int y, bg, TCOD_bkgnd_flag_t flag=TCOD_BKGND_SET):
  cdef TCOD_color_t bg_colour = parse_colour(bg)
  TCOD_console_set_char_background(con.con, x, y, bg_colour, flag)

def set_foreground(Console con not None, int x, int y, fg):
  cdef TCOD_color_t fg_colour = parse_colour(fg)
  TCOD_console_set_char_foreground(con.con, x, y, fg_colour)

def set_char(Console con not None, int x, int y, int ch):
  TCOD_console_set_char(con.con, x, y, ch)

def put_char(Console con not None, int x, int y, int ch, TCOD_bkgnd_flag_t flag=TCOD_BKGND_SET):
  TCOD_console_put_char(con.con, x, y, ch, flag)

def put_char_ex(Console con not None, int x, int y, int ch, fg, bg):
  cdef TCOD_color_t fg_colour = parse_colour(fg), \
                    bg_colour = parse_colour(bg)
  TCOD_console_put_char_ex(con.con, x, y, ch, fg_colour, bg_colour)

cdef TCOD_color_t parse_colour(c):
  cdef TCOD_color_t ret
  if isinstance(c, int):
    c = (c >> 4) & 0xFF, (c >> 2) & 0xFF, c & 0xFF
  if isinstance(c, tuple):
    ret.r, ret.g, ret.b = c
  else:
    ret = c
  return ret
