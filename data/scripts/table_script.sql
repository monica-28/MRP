PRAGMA foreign_keys = ON;

CREATE TABLE "customers" (
    xcustomer_id TEXT NOT NULL PRIMARY KEY,
    xname TEXT NOT NULL,
    xnif TEXT,
    xclient_group TEXT,
    xaddress TEXT
);

CREATE TABLE "suppliers" (
    xsupplier_id TEXT NOT NULL PRIMARY KEY,
    xname TEXT NOT NULL,
    xaddress TEXT,
    xnif TEXT,
    xshort_name TEXT
);

CREATE TABLE "items" (
    xitem_id TEXT NOT NULL PRIMARY KEY,
    xdescription TEXT,
    xshort_name TEXT,
    xfamiliy_id TEXT,
    xssfamily_id TEXT,
    xobsolete BOOLEAN NOT NULL DEFAULT 0 CHECK (xobsolete IN (0, 1)),
    xstandard_price REAL
);

CREATE TABLE "item_planning_parameters" (
    xitem_id TEXT NOT NULL PRIMARY KEY,
    xitem_type INTEGER NOT NULL CHECK (xitem_type IN (1, 2)),
    xlead_time_days INTEGER CHECK (xlead_time_days >= 0),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id)
);

CREATE TABLE "supplier_items" (
    xitem_id TEXT NOT NULL,
    xapproved BOOLEAN NOT NULL DEFAULT 1 CHECK (xapproved IN (0, 1)),
    xlead_time INTEGER CHECK (xlead_time >= 0),
    xsupplier_id TEXT NOT NULL,
    xlast_price NUMERIC,
    PRIMARY KEY (xitem_id, xsupplier_id),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id),
    FOREIGN KEY (xsupplier_id) REFERENCES suppliers (xsupplier_id)
);

CREATE TABLE "warehouse_inventory" (
    xwarehouse_id TEXT NOT NULL,
    xitem_id TEXT NOT NULL,
    xstock NUMERIC,
    xreorder_point NUMERIC,
    xmaximum_stock NUMERIC,
    xminimum_stock NUMERIC,
    PRIMARY KEY (xwarehouse_id, xitem_id),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id)
);

CREATE TABLE "sales_orders" (
    xsection_id TEXT NOT NULL,
    xtypedoc_id TEXT NOT NULL,
    xnumdoc_id INTEGER NOT NULL,
    xorder_date TEXT,
    xcustomer_id TEXT NOT NULL,
    PRIMARY KEY (xsection_id, xtypedoc_id, xnumdoc_id),
    FOREIGN KEY (xcustomer_id) REFERENCES customers (xcustomer_id)
);

CREATE TABLE "sales_order_lines" (
    xnumdoc_id INTEGER NOT NULL,
    xline_id INTEGER NOT NULL,
    xtypedoc_id TEXT NOT NULL,
    xsection_id TEXT NOT NULL,
    xquantity NUMERIC NOT NULL,
    xscheduled_delivery_date TEXT,
    xitem_id TEXT NOT NULL,
    PRIMARY KEY (xsection_id, xtypedoc_id, xnumdoc_id, xline_id),
    FOREIGN KEY (xsection_id, xtypedoc_id, xnumdoc_id)
        REFERENCES sales_orders (xsection_id, xtypedoc_id, xnumdoc_id),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id)
);

CREATE TABLE "delivery_notes" (
    xnumdoc_id INTEGER NOT NULL UNIQUE,
    xtypedoc_id TEXT NOT NULL CHECK (xtypedoc_id = '22'),
    xsection_id TEXT NOT NULL,
    xreference TEXT,
    xdeleted BOOLEAN NOT NULL DEFAULT 0 CHECK (xdeleted IN (0, 1)),
    xcycle_id INTEGER NOT NULL,
    xcustomer_id TEXT,
    xdelivery_note_date TEXT,
    PRIMARY KEY (xnumdoc_id, xtypedoc_id, xsection_id, xcycle_id),
    FOREIGN KEY (xcustomer_id) REFERENCES customers (xcustomer_id)
);

CREATE TABLE "delivey_notes_lines" (
    xnumdoc_id INTEGER NOT NULL,
    xtypedoc_id TEXT NOT NULL,
    xsection_id TEXT NOT NULL,
    xline_id INTEGER NOT NULL,
    xcycle_id INTEGER NOT NULL,
    xsale_order_typedoc_id TEXT,
    xsale_order_line_id INTEGER,
    xsale_numdoc_id INTEGER,
    xquantity NUMERIC,
    xitem_id TEXT NOT NULL,
    xdeleted BOOLEAN NOT NULL DEFAULT 0 CHECK (xdeleted IN (0, 1)),
    PRIMARY KEY (xnumdoc_id, xtypedoc_id, xsection_id, xcycle_id, xline_id),
    FOREIGN KEY (xnumdoc_id, xtypedoc_id, xsection_id, xcycle_id)
        REFERENCES delivery_notes (xnumdoc_id, xtypedoc_id, xsection_id, xcycle_id),
    FOREIGN KEY (xsection_id, xsale_order_typedoc_id, xsale_numdoc_id, xsale_order_line_id)
        REFERENCES sales_order_lines (xsection_id, xtypedoc_id, xnumdoc_id, xline_id),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id)
);

CREATE TABLE "purchase_orders" (
    xnumdoc_id INTEGER NOT NULL,
    xtypedoc_id TEXT NOT NULL,
    xsection_id TEXT NOT NULL,
    xsupplier_id TEXT NOT NULL,
    PRIMARY KEY (xnumdoc_id, xtypedoc_id, xsection_id),
    FOREIGN KEY (xsupplier_id) REFERENCES suppliers (xsupplier_id)
);

CREATE TABLE "purchase_order_lines" (
    xnumdoc_id INTEGER NOT NULL,
    xline_id INTEGER NOT NULL,
    xtypedoc_id TEXT NOT NULL,
    xsection_id TEXT NOT NULL,
    xitem_id TEXT NOT NULL,
    xquantity NUMERIC NOT NULL,
    xexpected_receipt_date TEXT,
    PRIMARY KEY (xnumdoc_id, xtypedoc_id, xsection_id, xline_id),
    FOREIGN KEY (xnumdoc_id, xtypedoc_id, xsection_id)
        REFERENCES purchase_orders (xnumdoc_id, xtypedoc_id, xsection_id),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id)
);

CREATE TABLE "bill_of_materials" (
    xcomponent_quantity NUMERIC NOT NULL CHECK (xcomponent_quantity > 0),
    xeffective_from TEXT,
    xeffective_to TEXT,
    xscrap_percentage NUMERIC,
    xbase_quantity NUMERIC CHECK (xbase_quantity > 0),
    xcomponent_item_id TEXT NOT NULL,
    xassembly_item_id TEXT NOT NULL,
    xcomponent_issue_warehouse_id TEXT,
    PRIMARY KEY (xassembly_item_id, xcomponent_item_id),
    FOREIGN KEY (xassembly_item_id) REFERENCES items (xitem_id),
    FOREIGN KEY (xcomponent_item_id) REFERENCES items (xitem_id),
    CHECK (xassembly_item_id <> xcomponent_item_id)
);

CREATE TABLE "production_orders" (
    xproduction_order_id INTEGER NOT NULL PRIMARY KEY,
    xassembly_item_id TEXT NOT NULL,
    xreleased_quantity NUMERIC NOT NULL CHECK (xreleased_quantity > 0),
    xcompleted_quantity NUMERIC NOT NULL DEFAULT 0,
    xproduction_notes TEXT,
    FOREIGN KEY (xassembly_item_id) REFERENCES items (xitem_id),
    CHECK (xcompleted_quantity BETWEEN 0 AND xreleased_quantity)
);

CREATE TABLE "production_order_components" (
    xactual_consumed_quantity NUMERIC,
    xrequired_quantity NUMERIC,
    xcomponent_item_id TEXT NOT NULL,
    xproduction_order_id INTEGER NOT NULL,
    xremaining_to_issue_quantity NUMERIC,
    PRIMARY KEY (xproduction_order_id, xcomponent_item_id),
    FOREIGN KEY (xproduction_order_id)
        REFERENCES production_orders (xproduction_order_id),
    FOREIGN KEY (xcomponent_item_id) REFERENCES items (xitem_id)
);

CREATE TABLE "sales_forecasts" (
    xitem_id TEXT NOT NULL,
    xforecast_quantity NUMERIC NOT NULL,
    xcompany_id TEXT NOT NULL,
    xrequirement_date TEXT NOT NULL,
    xforecast_id TEXT NOT NULL,
    PRIMARY KEY (xcompany_id, xforecast_id, xitem_id, xrequirement_date),
    FOREIGN KEY (xitem_id) REFERENCES items (xitem_id)
);



