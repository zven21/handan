import Ecto.Query, warn: false

alias Handan.{Repo, Turbo, Dispatcher}
alias Handan.{Accounts, Enterprise, Selling, Purchasing, Stock, Productions}

# Accounts
alias Accounts.Projections.User

# Enterprise
alias Enterprise.Projections.{Company, Warehouse, UOM}

# Selling
alias Selling.Projections.{SalesOrder, SalesOrderItem, Customer, SalesInvoice, DeliveryOrder, DeliveryOrderItem}

# Purchasing
alias Purchasing.Projections.{PurchaseOrder, PurchaseOrderItem, Supplier, PurchaseInvoice, ReceiptOrder, ReceiptOrderItem}

# Production
alias Productions.Projections.{WorkOrder, WorkOrderItem, Warehouse, BOM, BOMItem, Process, BOMProcess, JobCard, MaterialRequest}

# Stock
alias Stock.Projections.{StockUOM, StockItem, Item, InventoryEntry}

# Finance
alias Finance.Projections.{PaymentEntry, PaymentMethod}
