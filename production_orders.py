import sqlite3
from contextlib import closing

from config import DATABASE_PATH

def read_inventory() -> dict[str, float]:

    inventory = {}

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_inventory')
            results = cursor.fetchall()
            for row in results:
                key = row["xitem_id"]
                inventory[key] = float(row["stock"])
    
    return inventory


if __name__ == "__main__":
    inventory = read_inventory()
    keys = sorted(inventory.keys())

    for item in sorted(keys):
        stock = inventory.get(item)
        print(f"{item:<15} {stock:>12.2f}")