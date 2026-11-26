import sys
from pathlib import Path


def get_base_dir() -> Path:
    """
    Devuelve la carpeta principal de la aplicación.

    - Durante el desarrollo: carpeta raíz del proyecto.
    - Como ejecutable: carpeta donde se encuentra el .exe.
    """
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent

    return Path(__file__).resolve().parent

BASE_DIR = get_base_dir()

DATA_DIR = BASE_DIR / "data"

DATABASE_PATH = DATA_DIR / "mrp_demo.db"