from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = "vrl",
  ext_modules = cythonize("*.pyx")
)
