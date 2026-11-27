import sqlite3
from contextlib import closing

from config import DATABASE_PATH

def read_production_stock() -> tuple[dict[tuple[str, str], float], dict[str, float]]:

    active_production_stock = {}
    inactive_production_stock = {}
    

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_active_production_stock')
            results = cursor.fetchall()
            for row in results:
                key = (row["xassembly_item_id"], row["xcomponent_item_id"])
                active_production_stock[key] = float(row["production_stock"])

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_inactive_production_stock')
            results = cursor.fetchall()
            for row in results:
                key = row["xcomponent_item_id"]
                inactive_production_stock[key] = float(row["production_stock"])

    return active_production_stock, inactive_production_stock


if __name__ == "__main__":
    
    active_stock, inactive_stock = read_production_stock()
    keys = sorted(active_stock.keys())

    print("Active Production Stock:")
    for item in sorted(keys):
        stock = active_stock.get(item)
        print(f"{item[0]:<15} {item[1]:<15} {stock:>12.2f}")

    print("Inactive Production Stock:")
    for item in sorted(inactive_stock.keys()):
        stock = inactive_stock.get(item)
        print(f"{item:<15} {stock:>12.2f}")

