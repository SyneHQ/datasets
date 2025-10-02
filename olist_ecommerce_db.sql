CREATE DATABASE olist;
USE olist;

-- Creating table for olist_customers_dataset.csv
CREATE TABLE IF NOT EXISTS olist_customers_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_customers_dataset.csv', 'CSVWithNames');

-- Creating table for olist_geolocation_dataset.csv
CREATE TABLE IF NOT EXISTS olist_geolocation_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_geolocation_dataset.csv', 'CSVWithNames');

-- Creating table for olist_order_items_dataset.csv
CREATE TABLE IF NOT EXISTS olist_order_items_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_order_items_dataset.csv', 'CSVWithNames');

-- Creating table for olist_order_payments_dataset.csv
CREATE TABLE IF NOT EXISTS olist_order_payments_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_order_payments_dataset.csv', 'CSVWithNames');

-- Creating table for olist_order_reviews_dataset.csv
CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_order_reviews_dataset.csv', 'CSVWithNames');

-- Creating table for olist_orders_dataset.csv
CREATE TABLE IF NOT EXISTS olist_orders_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_orders_dataset.csv', 'CSVWithNames');

-- Creating table for olist_products_dataset.csv
CREATE TABLE IF NOT EXISTS olist_products_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_products_dataset.csv', 'CSVWithNames');

-- Creating table for olist_sellers_dataset.csv
CREATE TABLE IF NOT EXISTS olist_sellers_dataset
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/olist_sellers_dataset.csv', 'CSVWithNames');

-- Creating table for product_category_name_translation.csv
CREATE TABLE IF NOT EXISTS product_category_name_translation
ENGINE = MergeTree()
ORDER BY tuple()
AS SELECT * FROM url('https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0004mn3fo44wph5n/uofxbmdeAFKgQGfK/kaggle_olist_dataset/product_category_name_translation.csv', 'CSVWithNames');
