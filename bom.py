import sqlite3
from contextlib import closing
from collections import defaultdict

from config import DATABASE_PATH

def read_bom() -> tuple[dict[str, list[tuple[str, float]]], list[str]]:

    bom_by_assembly = defaultdict(list)
    bom_warnings: list[str] = []

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_bom ORDER BY xassembly_item_id')
            results = cursor.fetchall()
            for row in results:
                key = row["xassembly_item_id"]
                qty_per_assembly = row["quantity_per_assembly"]
                if qty_per_assembly is not None:
                    qty_per_assembly = float(qty_per_assembly)
                else:
                    qty_per_assembly = 1
                    bom_warnings.append(
                        f"BOM {key} → {row['xcomponent_item_id']}: " "quantity per assembly is null. Using 1.0.")

                bom_by_assembly[key].append((row["xcomponent_item_id"], qty_per_assembly))

    return bom_by_assembly, bom_warnings

if __name__ == "__main__":
    bom, warnings = read_bom()
    for assembly, components in bom.items():
        print(f"Assembly: {assembly}")
        for component, qty in components:
            print(f"  Component: {component}, Quantity per Assembly: {qty}")
    for warning in warnings:
        print(f"Warning: {warning}")

    