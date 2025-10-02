-- Drop the existing 'slice' database if it exists
DROP DATABASE slice;

-- Create a new database named 'slice' only if it doesn't already exist
CREATE DATABASE IF NOT EXISTS slice;

-- Switch to using the 'slice' database for subsequent operations
USE slice;

-- ===============================
-- Importing CSV Data from S3 URLs
-- ===============================

-- Create 'branches' table and load data from S3
CREATE TABLE IF NOT EXISTS branches
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/branches.csv',
  'CSV'
);

-- Create 'customers' table and load data from S3
CREATE TABLE IF NOT EXISTS customers
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/customers.csv',
  'CSV'
);

-- Create 'agents' table and load data from S3
CREATE TABLE IF NOT EXISTS agents
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/agents.csv',
  'CSV'
);

-- Create 'kyc' table and load data from S3
CREATE TABLE IF NOT EXISTS kyc
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/kyc.csv',
  'CSV'
);

-- Create 'loan_applications' table and load data from S3
CREATE TABLE IF NOT EXISTS loan_applications
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/loan_applications.csv',
  'CSV'
);

-- Create 'loans' table and load data from S3
CREATE TABLE IF NOT EXISTS loans
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/loans.csv',
  'CSV'
);

-- Create 'repayments' table and load data from S3
CREATE TABLE IF NOT EXISTS repayments
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT *
FROM s3(
  'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0002o13jw0iekpbd/Acme_SyntheticData/repayments.csv',
  'CSV'
);

-- Preview all the data loaded into 'branches'
SELECT * FROM slice.branches;
