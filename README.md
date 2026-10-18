# PostgreSQL Online Store Assessment

This project creates an `online_store` PostgreSQL database with users, products, orders, and order items. It includes constraints, foreign keys, indexes, sample data, required queries, and automated verification.

## Schema relationships

```text
users 1 ─── many orders 1 ─── many order_items many ─── 1 products
```

## Requirements

- PostgreSQL server
- PostgreSQL command-line client (`psql`)

Check the installation and service:

```bash
psql --version
sudo systemctl status postgresql
```

On Ubuntu/Debian, install PostgreSQL when needed:

```bash
sudo apt update
sudo apt install postgresql postgresql-client
sudo systemctl enable --now postgresql
```

## Automated setup

From this project folder:

```bash
chmod +x scripts/setup.sh
sudo ./scripts/setup.sh
```

The setup creates the database if necessary and can be safely rerun without duplicating sample rows.

## Run the required queries

```bash
sudo -u postgres psql -d online_store -f sql/03_queries.sql
```

The queries demonstrate:

- Fetching every product
- Retrieving orders for the user `anita`
- Displaying products and totals for each order
- Calculating total store revenue

## Verify the result

```bash
sudo -u postgres psql -v ON_ERROR_STOP=1 -d online_store -f sql/04_verify.sql
```

## Connect interactively

```bash
sudo -u postgres psql -d online_store
```

Useful commands:

```text
\dt
\d users
\d products
\d orders
\d order_items
\q
```

## Connect with pgAdmin

Register a server with the host, port, username, and password configured for your PostgreSQL installation, then select the `online_store` database. The default local PostgreSQL port is `5432`.

## Security note

The sample password values only resemble password hashes. Real applications must hash passwords with bcrypt or Argon2 and must not store plaintext passwords or commit database credentials.
