import sqlite3
from contextlib import closing

from config import DATABASE_PATH
from production_orders import read_production_stock

def read_item_parameters() -> tuple[dict[tuple[str, str], float], dict[str, float]]:

    parameters: dict[str, dict[str, ...]] = {}
    

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_items')
            results = cursor.fetchall()
            for row in results:
                key = row["xitem_id"]
                parameters[key] = {
                    "xdescription": row["xdescription"],
                    "xshort_name": row["xshort_name"],
                    "xfamily_id": row["xfamily_id"],
                    "xssfamily_id": row["xssfamily_id"],
                    "xstandard_price": float(row["xstandard_price"]) if row["xstandard_price"] is not None else 0.0,
                    "xitem_type": int(row["xitem_type"]),
                    "xlead_time_days": int(row["xlead_time_days"]) if row["xlead_time_days"] is not None else 0
                }
    return parameters

if __name__ == "__main__":
    parameters = read_item_parameters()
    keys = sorted(parameters.keys())

    header = (
        f"{'Item':<15} {'Description':<30} {'Short Name':<15} "
        f"{'Family':<15} {'Subfamily':<15} {'Price':>12} {'Type':<5} {'Lead Time':>5}"
    )
    print(header)
    print("-" * len(header))

    for item in sorted(keys):
        param = parameters.get(item)
        print(f"{item:<15} {param['xdescription']:<30} {param['xshort_name']:<15} "
              f"{param['xfamily_id']:<15} {param['xssfamily_id']:<15} "
              f"{param['xstandard_price']:>12.2f} {param['xitem_type']:<5} "
              f"{param['xlead_time_days']:>5}")
