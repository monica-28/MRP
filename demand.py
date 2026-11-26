import sqlite3
from contextlib import closing

from config import DATABASE_PATH


def read_demand() -> tuple[dict[tuple[str, ...], float], dict[tuple[str, ...], float], dict[tuple[str, ...], float]]:

    deliveries = {}
    ordered_items = {}
    forecasted_items = {}

    with closing(sqlite3.connect(DATABASE_PATH)) as conn:
        conn.row_factory = sqlite3.Row

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_weekly_delivery_notes')
            results = cursor.fetchall()
            for row in results:
                key = (row["xitem_id"], row["week_start"])
                deliveries[key] = float(row["delivered_qty"])

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_weekly_orders')
            results = cursor.fetchall()
            for row in results:
                key = (row["xitem_id"], row["week_start"])
                ordered_items[key] = float(row["pending_qty"])

        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM v_weekly_forecast')
            results = cursor.fetchall()
            for row in results:
                key = (row["xitem_id"], row["week_start"])
                forecasted_items[key] = float(row["forecast_qty"])

    return deliveries, ordered_items, forecasted_items

def get_real_needs(deliveries: dict[tuple[str, ...], float], ordered_items: dict[tuple[str, ...], float], forecasted_items: dict[tuple[str, ...], float]) -> dict[tuple[str, ...], float]:
    """
    Calcula las necesidades reales de los artículos en función de las entregas, pedidos y pronósticos.

    Args:
        deliveries (dict): Diccionario con las entregas realizadas.
        ordered_items (dict): Diccionario con los artículos pedidos.
        forecasted_items (dict): Diccionario con los artículos pronosticados.

    Returns:
        dict: Diccionario con las necesidades reales de los artículos.
    """

    # Get the real needs
    weekly_keys = ordered_items.keys() | forecasted_items.keys()
    real_needs = {}

    for key in sorted(weekly_keys):
        item, week = key
        delivered_qty = deliveries.get(key, 0)
        ordered_qty = ordered_items.get(key, 0)
        forecasted_qty = forecasted_items.get(key, 0)

        if forecasted_qty - delivered_qty > ordered_qty:
            real_need = forecasted_qty - delivered_qty
        else:
            real_need = ordered_qty
        if real_need > 0:
            real_needs[key] = real_need

    return real_needs

if __name__ == "__main__":
    deliveries, ordered_items, forecasted_items = read_demand()
    real_needs = get_real_needs(deliveries, ordered_items, forecasted_items)

    weekly_keys = deliveries.keys() | ordered_items.keys() | forecasted_items.keys()

    header = (
        f"{'Artículo':<15} {'Lunes':<12} {'Entregado':>12} "
        f"{'Pendiente':>12} {'Previsión':>12} {'Necesidad':>12}"
    )
    print(header)
    print("-" * len(header))

    for item, week_start in sorted(weekly_keys):
        key = (item, week_start)
        delivered_qty = deliveries.get(key, 0)
        pending_qty = ordered_items.get(key, 0)
        forecast_qty = forecasted_items.get(key, 0)
        need_qty = real_needs.get(key, 0)

        print(
            f"{item:<15} {week_start:<12} {delivered_qty:>12.2f} "
            f"{pending_qty:>12.2f} {forecast_qty:>12.2f} {need_qty:>12.2f}"
        )