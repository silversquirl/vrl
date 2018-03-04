from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

extensions = [
  Extension("tcod/*", ["tcod/*.pyx"]),
  Extension("*", ["*.pyx"]),
]

setup(
  name = "vrl",
  ext_modules = cythonize(extensions)
)
