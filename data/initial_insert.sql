INSERT INTO customers
    (xcustomer_id, xname, xnif, xclient_group, xaddress)
VALUES
    ('098101', 'Lúmora Control Industrial', NULL, 'LUMORA', 'Vía de Ensayo 14, Nave 3'),
    ('098102', 'Vértice Sensorial', NULL, NULL, NULL),
    ('098103', 'Nebral Automatismos', 'TEST-CLI-03', NULL, 'Pasaje de Prototipos 8');

INSERT INTO suppliers
    (xsupplier_id, xname, xaddress, xnif, xshort_name)
VALUES
    ('9811', 'Cirdal Circuitos', 'Vía de Ensayo 38', NULL, 'CIRDAL'),
    ('9812', 'Conexia Banco de Pruebas', NULL, 'TEST-PRO-02', 'CONEXIA'),
    ('9813', 'Mecánica Valdema', 'Calle de Utillajes 12', NULL, NULL);

INSERT INTO items
    (xitem_id, xdescription, xshort_name, xfamiliy_id,
     xssfamily_id, xobsolete, xstandard_price)
VALUES
    ('0000098101', 'Placa de circuito impreso', 'PCB BASE', 'COMP', 'PCB', 0, 2.80),
    ('0000098102', 'Conector de 6 polos', 'CONEC 6P', 'COMP', 'CON', 0, 0.42),
    ('0000098103', 'Carcasa ABS', 'CAJA ABS', 'MEC', 'CAR', 0, 1.65),
    ('0000098104', 'Tornillo M3', 'TOR M3', 'MEC', 'TOR', 0, 0.04),
    ('0000098105', 'Conector de 4 polos descatalogado', 'CONEC 4P', 'COMP', 'CON', 1, 0.38),
    ('0000098106', 'Placa de control ensamblada', 'PLACA CTRL', 'FAB', 'SUB', 0, 8.50),
    ('0000098107', 'Módulo de control doble', 'MOD DOBLE', 'FAB', 'FIN', 0, 23.40),
    ('0000098108', 'Módulo de control compacto', 'MOD COMPACTO', 'FAB', 'FIN', 0, 13.75);

INSERT INTO item_planning_parameters
    (xitem_id, xitem_type, xlead_time_days)
VALUES
    ('0000098101', 1, 7),
    ('0000098102', 1, 5),
    ('0000098103', 1, 4),
    ('0000098104', 1, 3),
    ('0000098105', 1, NULL),
    ('0000098106', 2, 3),
    ('0000098107', 2, 2),
    ('0000098108', 2, 2);

INSERT INTO supplier_items
    (xitem_id, xapproved, xlead_time, xsupplier_id, xlast_price)
VALUES
    ('0000098101', 1, 7, '9811', 2.75),
    ('0000098101', 0, 4, '9812', 2.95),
    ('0000098102', 1, 5, '9812', 0.40),
    ('0000098102', 1, 8, '9811', 0.44),
    ('0000098103', 1, 4, '9813', 1.60),
    ('0000098104', 1, 3, '9813', 0.038);

INSERT INTO warehouse_inventory
    (xwarehouse_id, xitem_id, xstock, xreorder_point, xmaximum_stock, xminimum_stock)
VALUES
    ('1', '0000098101', 75, 25, 500, 10),
    ('1', '0000098102', 240, 50, 1000, 20),
    ('1', '0000098103', 85, 20, 200, 5),
    ('1', '0000098104', 400, 100, 2000, 40),
    ('1', '0000098105', 0, 0, 0, 0),
    ('1', '0000098106', 45, 0, 100, 0),
    ('1', '0000098107', 10, 0, 100, 0),
    ('1', '0000098108', 25, 0, 80, 0);

INSERT INTO sales_orders
    (xsection_id, xtypedoc_id, xnumdoc_id, xorder_date, xcustomer_id)
VALUES
    ('0', '21', 98301, '2026-11-04', '098101'),
    ('0', '21', 98302, '2026-11-05', '098102'),
    ('0', '21', 98303, '2026-11-12', '098103');

INSERT INTO sales_order_lines
    (xnumdoc_id, xline_id, xtypedoc_id, xsection_id,
     xquantity, xscheduled_delivery_date, xitem_id)
VALUES
    (98301, 10, '21', '0', 100, '2026-11-30', '0000098107'),
    (98301, 20, '21', '0', 5, '2026-11-30', '0000098108'),
    (98302, 10, '21', '0', 12, '2026-11-17', '0000098108'),
    (98303, 10, '21', '0', 15, '2026-12-01', '0000098108');

INSERT INTO delivery_notes
    (xnumdoc_id, xtypedoc_id, xsection_id, xreference,
     xdeleted, xcycle_id, xcustomer_id, xdelivery_note_date)
VALUES
    (98201, '22', '0', 'Entrega parcial', 0, 2026, '098101', '2026-11-16'),
    (98202, '22', '0', 'Entrega completa', 0, 2026, '098102', '2026-11-17'),
    (98203, '22', '0', 'Entrega anulada', 1, 2026, '098101', '2026-11-18');

INSERT INTO delivey_notes_lines
    (xnumdoc_id, xtypedoc_id, xsection_id, xline_id, xcycle_id,
     xsale_order_typedoc_id, xsale_order_line_id, xsale_numdoc_id,
     xquantity, xitem_id, xdeleted)
VALUES
    (98201, '22', '0', 10, 2026, '21', 10, 98301, 20, '0000098107', 0),
    (98201, '22', '0', 20, 2026, '21', 10, 98301, 10, '0000098107', 0),
    (98202, '22', '0', 10, 2026, '21', 10, 98302, 12, '0000098108', 0),
    (98203, '22', '0', 10, 2026, '21', 10, 98301, 5, '0000098107', 1);

INSERT INTO purchase_orders
    (xnumdoc_id, xtypedoc_id, xsection_id, xsupplier_id)
VALUES
    (98401, '11', '0', '9811'),
    (98402, '11', '0', '9811'),
    (98403, '11', '0', '9813');

INSERT INTO purchase_order_lines
    (xnumdoc_id, xline_id, xtypedoc_id, xsection_id,
     xitem_id, xquantity, xexpected_receipt_date)
VALUES
    (98401, 10, '11', '0', '0000098101', 50, '2026-11-24'),
    (98402, 10, '11', '0', '0000098101', 100, '2026-12-02'),
    (98403, 10, '11', '0', '0000098103', 70, '2026-12-03'),
    (98403, 20, '11', '0', '0000098104', 200, '2026-12-03');

INSERT INTO bill_of_materials
    (xcomponent_quantity, xeffective_from, xeffective_to, xscrap_percentage,
     xbase_quantity, xcomponent_item_id, xassembly_item_id, xcomponent_issue_warehouse_id)
VALUES
    (2, '2026-10-01', NULL, 0, 1, '0000098101', '0000098106', '1'),
    (3, '2026-10-01', NULL, 0, 1, '0000098102', '0000098106', '1'),
    (2, '2026-10-01', NULL, 0, 1, '0000098106', '0000098107', '1'),
    (1, '2026-10-01', NULL, 0, 1, '0000098103', '0000098107', '1'),
    (4, '2026-10-01', NULL, 0, 1, '0000098104', '0000098107', '1'),
    (1, '2026-10-01', NULL, 0, 1, '0000098106', '0000098108', '1'),
    (1, '2026-10-01', NULL, 0, 1, '0000098103', '0000098108', '1'),
    (2, '2026-10-01', NULL, 0, 1, '0000098104', '0000098108', '1');

INSERT INTO production_orders
    (xproduction_order_id, xassembly_item_id,
     xreleased_quantity, xcompleted_quantity, xproduction_notes)
VALUES
    (98501, '0000098107', 30, 10, 'Módulo doble · lote en curso'),
    (98502, '0000098106', 20, 5, 'Placa ensamblada · lote en curso'),
    (98503, '0000098108', 12, 12, 'Módulo compacto · lote terminado');

INSERT INTO production_order_components
    (xactual_consumed_quantity, xrequired_quantity, xcomponent_item_id,
     xproduction_order_id, xremaining_to_issue_quantity)
VALUES
    (20, 60, '0000098106', 98501, 40),
    (10, 30, '0000098103', 98501, 20),
    (40, 120, '0000098104', 98501, 80),
    (10, 40, '0000098101', 98502, 30),
    (15, 60, '0000098102', 98502, 45),
    (12, 12, '0000098106', 98503, 0),
    (12, 12, '0000098103', 98503, 0),
    (24, 24, '0000098104', 98503, 0);

INSERT INTO sales_forecasts
    (xitem_id, xforecast_quantity, xcompany_id, xrequirement_date, xforecast_id)
VALUES
    ('0000098108', 30, 'DEMO', '2026-12-09', 'PV-DEMO-01'),
    ('0000098107', 20, 'DEMO', '2026-12-15', 'PV-DEMO-01'),
    ('0000098108', 15, 'DEMO', '2026-12-22', 'PV-DEMO-02');