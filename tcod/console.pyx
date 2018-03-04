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

  ctypedef struct TCOD_key_t:
    # TODO: support more fields
    unsigned char c
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
  return TCOD_console_wait_for_keypress(flush)

# --- Drawing ---
def flush():
  TCOD_console_flush()

def clear(Console con):
  TCOD_console_clear(con.con)

def set_background(Console con, int x, int y, bg, TCOD_bkgnd_flag_t flag=TCOD_BKGND_SET):
  cdef TCOD_color_t bg_colour = parse_colour(bg)
  TCOD_console_set_char_background(con.con, x, y, bg_colour, flag)

def set_foreground(Console con, int x, int y, fg):
  cdef TCOD_color_t fg_colour = parse_colour(fg)
  TCOD_console_set_char_foreground(con.con, x, y, fg_colour)

def set_char(Console con, int x, int y, int ch):
  TCOD_console_set_char(con.con, x, y, ch)

def put_char(Console con, int x, int y, int ch, TCOD_bkgnd_flag_t flag=TCOD_BKGND_SET):
  TCOD_console_put_char(con.con, x, y, ch, flag)

def put_char_ex(Console con, int x, int y, int ch, fg, bg):
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
