from bom import read_bom
from inventory import read_inventory
from production_orders import read_production_stock
from demand import read_demand, get_real_needs
from item_parameters import read_item_parameters
from open_purchase_orders import read_open_purchase_orders

def get_component_needs():
    bom, bom_warnings = read_bom()
    inventory = read_inventory()
    active_stock, inactive_stock = read_production_stock()
    open_purchases = read_open_purchase_orders()
    deliveries, ordered_items, forecasted_items = read_demand()
    real_needs = get_real_needs(deliveries, ordered_items, forecasted_items)
    parameters = read_item_parameters()

    component_needs = {}

    for item in real_needs:
        for week_start, need_qty in real_needs[item]:
            inventory_stock = inventory.get(item, 0)

            need_qty -=inventory_stock
            if need_qty > 0:# Update inventory after considering the need
                inventory[item] = 0
            else:
                inventory[item] -= need_qty
                continue  # No need for components if we have enough stock        

            reserved_stock = inactive_stock.get(item, 0)
            need_qty -= reserved_stock
            if need_qty > 0:# Update inactive stock after considering the need
                inactive_stock[item] = 0
            else:
                inactive_stock[item] -= need_qty
                continue  # No need for components if we have enough stock
            bucle(need_qty, item, week_start, component_needs, bom, active_stock, inactive_stock, inventory, open_purchases, parameters)






def bucle(need_qty, item, week_start, component_needs, bom, active_stock, inactive_stock, inventory, open_purchases, parameters):
    for component, qty_per_assembly in bom.get(item, []):
        component_need = need_qty * qty_per_assembly

        available_stock = active_stock.get((item,component, 0))
        component_need -= available_stock
        if component_need > 0:# Update active stock after considering the need
            active_stock[(item,component)] = 0
        else:
            active_stock[(item,component)] -= component_need
            continue  # No need for components if we have enough stock
        
        inventory_stock = inventory.get(component, 0)
        component_need -=inventory_stock
        if component_need > 0:# Update inventory after considering the need
            inventory[component] = 0
        else:
            inventory[component] -= component_need
            continue  # No need for components if we have enough stock        

        reserved_stock = inactive_stock.get(component, 0)
        component_need -= reserved_stock
        if component_need > 0:# Update inactive stock after considering the need
            inactive_stock[component] = 0
        else:
            inactive_stock[component] -= component_need
            continue  # No need for components if we have enough stock

        if parameters.get(component, {}).get("xitem_type") == 1:  # Check if the component is a purchased item
            purchased_qty = open_purchases.get((component, week_start), 0)
            component_need -= purchased_qty

            if component_need > 0:  # If there's still a need after considering purchased items
                # Update open purchases after considering the need
                open_purchases[(component, week_start)] = 0
            else:
                open_purchases[(component, week_start)] -= component_need
                continue  # No need for components if we have enough stock

            if component not in component_needs:
                component_needs[component] = []
            component_needs[component].append((week_start, component_need))
        else:
             bucle(component_need, component, week_start, component_needs, bom, active_stock, inactive_stock, inventory, open_purchases, parameters)


                
            

    