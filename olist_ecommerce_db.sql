CREATE DATABASE if not EXISTS olist;

USE olist;

-- Creating table for olist_customers_dataset.csv
CREATE TABLE IF NOT EXISTS olist.customers_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_customers_dataset.csv', 'CSVWithNames');

-- Creating table for olist_geolocation_dataset.csv
CREATE TABLE IF NOT EXISTS olist.geolocation_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_geolocation_dataset.csv', 'CSVWithNames');

-- Creating table for olist_order_items_dataset.csv
CREATE TABLE IF NOT EXISTS olist.order_items_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_order_items_dataset.csv', 'CSVWithNames');

-- Creating table for olist_order_payments_dataset.csv
CREATE TABLE IF NOT EXISTS olist.order_payments_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_order_payments_dataset.csv', 'CSVWithNames');

-- Creating table for olist_order_reviews_dataset.csv
CREATE TABLE IF NOT EXISTS olist.order_reviews_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_order_reviews_dataset.csv', 'CSVWithNames');

-- Creating table for olist_orders_dataset.csv
CREATE TABLE IF NOT EXISTS olist.orders_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_orders_dataset.csv', 'CSVWithNames');

-- Creating table for olist_products_dataset.csv
CREATE TABLE IF NOT EXISTS olist.products_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_products_dataset.csv', 'CSVWithNames');

-- Creating table for olist_sellers_dataset.csv
CREATE TABLE IF NOT EXISTS olist.sellers_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_sellers_dataset.csv', 'CSVWithNames');

-- Creating table for product_category_name_translation.csv
CREATE TABLE IF NOT EXISTS product_category_name_translation
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/product_category_name_translation.csv', 'CSVWithNames');

SELECT
    'customers_dataset' AS table_name, count(*) AS total_records FROM olist.customers_dataset
UNION ALL
SELECT
    'geolocation_dataset', count(*) FROM olist.geolocation_dataset
UNION ALL
SELECT
    'order_items_dataset', count(*) FROM olist.order_items_dataset
UNION ALL
SELECT
    'order_payments_dataset', count(*) FROM olist.order_payments_dataset
UNION ALL
SELECT
    'order_reviews_dataset', count(*) FROM olist.order_reviews_dataset
UNION ALL
SELECT
    'orders_dataset', count(*) FROM olist.orders_dataset
UNION ALL
SELECT
    'products_dataset', count(*) FROM olist.products_dataset
UNION ALL
SELECT
    'sellers_dataset', count(*) FROM olist.sellers_dataset
UNION ALL
SELECT
    'product_category_name_translation', count(*) FROM product_category_name_translation;
