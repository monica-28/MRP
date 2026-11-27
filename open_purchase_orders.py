from datetime import date
import sqlite3
from contextlib import closing

from config import DATABASE_PATH


def read_open_purchase_orders() -> tuple[dict[tuple[str, date], float], dict[tuple[str, date], float], dict[tuple[str, date], float]]:

    purchases: dict[tuple[str, date], float] = {}

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_purchase_orders')
            results = cursor.fetchall()
            for row in results:
                week_start = date.fromisoformat(row["week_start"])
                key = (row["xitem_id"], week_start)
                purchases[key] = float(row["purchased_qty"])
    
    return purchases

if __name__ == "__main__":
    purchases = read_open_purchase_orders()
    keys = sorted(purchases.keys())

    print(f"{'Item':<15} {'Week Start':<12} {'Purchased Qty':>12}")
    print("-" * 45)

    for item, week_start in keys:
        purchased_qty = purchases.get((item, week_start), 0)
        print(f"{item:<15} {week_start.strftime('%Y-%m-%d'):<12} {purchased_qty:>12.2f}")