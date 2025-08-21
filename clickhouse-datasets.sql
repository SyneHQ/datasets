-- ClickHouse SQL Script to Create Unified Multi-Domain Dataset Catalog
-- Author: SyneHQ (harsh@synehq.com)
-- Description: Creates databases and tables for E-commerce, Finance, Healthcare, Manufacturing, and Digital Product datasets
-- Date: 2025-08-21

-- ================================================================================
-- DATABASE CREATION
-- ================================================================================

-- Create main databases for each domain
CREATE DATABASE IF NOT EXISTS ecommerce_retail;
CREATE DATABASE IF NOT EXISTS finance_banking;
CREATE DATABASE IF NOT EXISTS healthcare_pharma;
CREATE DATABASE IF NOT EXISTS manufacturing_logistics;
CREATE DATABASE IF NOT EXISTS digital_product;

-- ================================================================================
-- E-COMMERCE & RETAIL DOMAIN
-- ================================================================================

-- UCI Online Retail Dataset
CREATE TABLE IF NOT EXISTS ecommerce_retail.online_retail_transactions (
    InvoiceNo String,
    StockCode String,
    Description String,
    Quantity Int32,
    InvoiceDate DateTime,
    UnitPrice Decimal(10,2),
    CustomerID Nullable(String),
    Country String,
    -- Derived columns for analysis
    TotalAmount Decimal(10,2) MATERIALIZED Quantity * UnitPrice,
    IsReturn UInt8 MATERIALIZED if(startsWith(InvoiceNo, 'C'), 1, 0),
    Year UInt16 MATERIALIZED toYear(InvoiceDate),
    Month UInt8 MATERIALIZED toMonth(InvoiceDate),
    DayOfWeek UInt8 MATERIALIZED toDayOfWeek(InvoiceDate),
    Quarter UInt8 MATERIALIZED toQuarter(InvoiceDate)
) ENGINE = MergeTree()
PARTITION BY (Year, Month)
ORDER BY (InvoiceDate, CustomerID, StockCode)
SETTINGS index_granularity = 8192;

-- Customer dimension table
CREATE TABLE IF NOT EXISTS ecommerce_retail.dim_customers (
    CustomerID String,
    Country String,
    FirstOrderDate DateTime,
    LastOrderDate DateTime,
    TotalOrders UInt32,
    TotalRevenue Decimal(12,2),
    AvgOrderValue Decimal(10,2),
    ProductsOrdered UInt32,
    CustomerSegment String
) ENGINE = ReplacingMergeTree()
ORDER BY CustomerID
SETTINGS index_granularity = 8192;

-- Product dimension table
CREATE TABLE IF NOT EXISTS ecommerce_retail.dim_products (
    StockCode String,
    Description String,
    FirstSaleDate DateTime,
    LastSaleDate DateTime,
    TotalQuantitySold UInt32,
    TotalRevenue Decimal(12,2),
    AvgUnitPrice Decimal(10,2),
    UniqueCustomers UInt32,
    ProductCategory String
) ENGINE = ReplacingMergeTree()
ORDER BY StockCode
SETTINGS index_granularity = 8192;

-- ================================================================================
-- FINANCE & BANKING DOMAIN
-- ================================================================================

-- Banking transactions dataset
CREATE TABLE IF NOT EXISTS finance_banking.banking_transactions (
    CustomerID String,
    TransactionDate Date,
    TransactionType String,
    TransactionAmount Decimal(15,2),
    AccountBalance Decimal(15,2),
    CustomerAge UInt8,
    CustomerGender Enum('M', 'F', 'Other'),
    AccountType Enum('Savings', 'Checking', 'Credit', 'Investment'),
    BranchCode String,
    AccountOpeningDate Date,
    TransactionDescription String,
    -- Derived columns
    TransactionMonth UInt8 MATERIALIZED toMonth(TransactionDate),
    TransactionYear UInt16 MATERIALIZED toYear(TransactionDate),
    TransactionQuarter UInt8 MATERIALIZED toQuarter(TransactionDate),
    DayOfWeek UInt8 MATERIALIZED toDayOfWeek(TransactionDate),
    IsWeekend UInt8 MATERIALIZED if(toDayOfWeek(TransactionDate) IN (6,7), 1, 0),
    AbsTransactionAmount Decimal(15,2) MATERIALIZED abs(TransactionAmount),
    IsDebit UInt8 MATERIALIZED if(TransactionAmount < 0, 1, 0)
) ENGINE = MergeTree()
PARTITION BY (TransactionYear, TransactionMonth)
ORDER BY (TransactionDate, CustomerID, BranchCode)
SETTINGS index_granularity = 8192;

-- Customer banking profile
CREATE TABLE IF NOT EXISTS finance_banking.customer_profiles (
    CustomerID String,
    CustomerAge UInt8,
    CustomerGender Enum('M', 'F', 'Other'),
    AccountType Enum('Savings', 'Checking', 'Credit', 'Investment'),
    BranchCode String,
    AccountOpeningDate Date,
    CurrentBalance Decimal(15,2),
    AvgMonthlyTransactions UInt16,
    TotalTransactionVolume Decimal(15,2),
    RiskScore UInt8,
    CustomerSegment String
) ENGINE = ReplacingMergeTree()
ORDER BY CustomerID
SETTINGS index_granularity = 8192;

-- ================================================================================
-- HEALTHCARE & PHARMACEUTICALS DOMAIN
-- ================================================================================

-- CDC Chronic Disease Indicators
CREATE TABLE IF NOT EXISTS healthcare_pharma.chronic_disease_indicators (
    YearStart UInt16,
    YearEnd UInt16,
    LocationAbbr String,
    LocationDesc String,
    DataSource String,
    Topic String,
    Question String,
    Response String,
    DataValueUnit String,
    DataValueType String,
    DataValue Nullable(Float32),
    DataValueAlt Nullable(Float32),
    DataValueFootnoteSymbol Nullable(String),
    DatavalueFootnote Nullable(String),
    LowConfidenceLimit Nullable(Float32),
    HighConfidenceLimit Nullable(Float32),
    StratificationCategory1 String,
    Stratification1 String,
    StratificationCategory2 String,
    Stratification2 String,
    StratificationCategory3 String,
    Stratification3 String,
    GeoLocation String,
    ResponseID String,
    LocationID String,
    QuestionID String,
    TopicID String,
    -- Derived columns
    DataYearRange UInt8 MATERIALIZED YearEnd - YearStart + 1,
    IsStateLevel UInt8 MATERIALIZED if(LocationDesc != 'United States', 1, 0),
    HasConfidenceInterval UInt8 MATERIALIZED if(LowConfidenceLimit IS NOT NULL AND HighConfidenceLimit IS NOT NULL, 1, 0)
) ENGINE = MergeTree()
PARTITION BY (YearStart, Topic)
ORDER BY (YearStart, LocationDesc, Topic, QuestionID)
SETTINGS index_granularity = 8192;

-- Location dimension for healthcare
CREATE TABLE IF NOT EXISTS healthcare_pharma.dim_locations (
    LocationID String,
    LocationAbbr String,
    LocationDesc String,
    LocationType String, -- State, Territory, National
    Region String,
    Population UInt32
) ENGINE = ReplacingMergeTree()
ORDER BY LocationID
SETTINGS index_granularity = 8192;

-- ================================================================================
-- MANUFACTURING & LOGISTICS DOMAIN
-- ================================================================================

-- Comprehensive logistics and supply chain dataset
CREATE TABLE IF NOT EXISTS manufacturing_logistics.supply_chain_operations (
    Timestamp DateTime,
    VehicleGPSLatitude Float32,
    VehicleGPSLongitude Float32,
    FuelConsumptionRate Float32,
    ETAVariationHours Float32,
    TrafficCongestionLevel UInt8, -- 0-10 scale
    WarehouseInventoryLevel UInt32,
    LoadingUnloadingTime Float32,
    HandlingEquipmentAvailability UInt8, -- 0=unavailable, 1=available
    OrderFulfillmentStatus UInt8, -- 0=not fulfilled, 1=fulfilled
    WeatherConditionSeverity Float32, -- 0-1 scale
    PortCongestionLevel UInt8, -- 0-10 scale
    ShippingCosts Decimal(10,2),
    SupplierReliabilityScore Float32, -- 0-1 scale
    LeadTimeDays UInt16,
    HistoricalDemand UInt32,
    IoTTemperature Float32,
    CargoConditionStatus UInt8, -- 0=poor, 1=good
    RouteRiskLevel UInt8, -- 0-10 scale
    CustomsClearanceTime Float32,
    DriverBehaviorScore Float32, -- 0-1 scale
    FatigueMonitoringScore Float32, -- 0-1 scale
    -- Target variables
    DisruptionLikelihoodScore Float32, -- 0-1 scale
    DelayProbability Float32, -- 0-1 scale
    RiskClassification Enum('Low Risk', 'Moderate Risk', 'High Risk'),
    DeliveryTimeDeviation Float32,
    -- Derived columns
    Date Date MATERIALIZED toDate(Timestamp),
    Hour UInt8 MATERIALIZED toHour(Timestamp),
    DayOfWeek UInt8 MATERIALIZED toDayOfWeek(Timestamp),
    Month UInt8 MATERIALIZED toMonth(Timestamp),
    Year UInt16 MATERIALIZED toYear(Timestamp),
    IsHighRisk UInt8 MATERIALIZED if(RiskClassification = 'High Risk', 1, 0),
    FuelEfficiency Float32 MATERIALIZED if(FuelConsumptionRate > 0, 1/FuelConsumptionRate, 0),
    IsDelayed UInt8 MATERIALIZED if(ETAVariationHours > 0, 1, 0)
) ENGINE = MergeTree()
PARTITION BY (Year, Month)
ORDER BY (Timestamp, VehicleGPSLatitude, VehicleGPSLongitude)
SETTINGS index_granularity = 8192;

-- Vehicle tracking dimension
CREATE TABLE IF NOT EXISTS manufacturing_logistics.dim_vehicles (
    VehicleID String,
    VehicleType String,
    Capacity Float32,
    FuelType String,
    LastMaintenanceDate Date,
    OperationalStatus String
) ENGINE = ReplacingMergeTree()
ORDER BY VehicleID
SETTINGS index_granularity = 8192;

-- ================================================================================
-- DIGITAL PRODUCT DOMAIN
-- ================================================================================

-- Clickstream events table
CREATE TABLE IF NOT EXISTS digital_product.clickstream_events (
    EventID String,
    UserID String,
    SessionID String,
    EventType String, -- page_view, click, scroll, form_submit, etc.
    PageURL String,
    PageTitle String,
    Referrer String,
    Timestamp DateTime,
    DeviceType String,
    Browser String,
    Properties String, -- JSON string for custom properties
    -- Parsed properties for common analytics
    BrowserVersion Nullable(String),
    ScreenWidth Nullable(UInt16),
    ScreenHeight Nullable(UInt16),
    UserAgent String,
    IPAddress String,
    Country String,
    City String,
    -- Derived columns
    Date Date MATERIALIZED toDate(Timestamp),
    Hour UInt8 MATERIALIZED toHour(Timestamp),
    DayOfWeek UInt8 MATERIALIZED toDayOfWeek(Timestamp),
    Month UInt8 MATERIALIZED toMonth(Timestamp),
    Year UInt16 MATERIALIZED toYear(Timestamp),
    IsWeekend UInt8 MATERIALIZED if(toDayOfWeek(Timestamp) IN (6,7), 1, 0),
    TimeBucket DateTime MATERIALIZED toStartOfInterval(Timestamp, INTERVAL 5 MINUTE)
) ENGINE = MergeTree()
PARTITION BY (Year, Month, Day)
ORDER BY (Timestamp, UserID, SessionID)
SETTINGS index_granularity = 8192;

-- User sessions table
CREATE TABLE IF NOT EXISTS digital_product.user_sessions (
    SessionID String,
    UserID String,
    SessionStart DateTime,
    SessionEnd DateTime,
    PageViews UInt32,
    UniquePages UInt32,
    TotalClicks UInt32,
    SessionDuration UInt32, -- in seconds
    DeviceType String,
    Browser String,
    EntryPage String,
    ExitPage String,
    Country String,
    IsConverted UInt8, -- 1 if session led to conversion, 0 otherwise
    ConversionValue Decimal(10,2),
    -- Derived columns
    Date Date MATERIALIZED toDate(SessionStart),
    Hour UInt8 MATERIALIZED toHour(SessionStart),
    BounceRate Float32 MATERIALIZED if(PageViews = 1, 1.0, 0.0)
) ENGINE = MergeTree()
PARTITION BY (toYYYYMM(Date))
ORDER BY (SessionStart, UserID)
SETTINGS index_granularity = 8192;

-- ================================================================================
-- DATA LOADING INSTRUCTIONS
-- ================================================================================

-- Instructions for loading data into each table:
-- Note: Replace 'path/to/data/' with actual file paths

-- E-commerce data loading (UCI Online Retail)
-- INSERT INTO ecommerce_retail.online_retail_transactions 
-- SELECT * FROM file('path/to/data/online_retail.csv', 'CSV', 
--   'InvoiceNo String, StockCode String, Description String, Quantity Int32, 
--    InvoiceDate String, UnitPrice Decimal(10,2), CustomerID String, Country String')
-- WHERE CustomerID IS NOT NULL AND CustomerID != '';

-- Banking data loading
-- INSERT INTO finance_banking.banking_transactions 
-- SELECT * FROM file('path/to/data/banking_dataset.csv', 'CSV', 
--   'CustomerID String, TransactionDate String, TransactionType String, 
--    TransactionAmount Decimal(15,2), AccountBalance Decimal(15,2), 
--    CustomerAge UInt8, CustomerGender String, AccountType String, 
--    BranchCode String, AccountOpeningDate String, TransactionDescription String');

-- Healthcare data loading (CDC Chronic Disease Indicators)
-- INSERT INTO healthcare_pharma.chronic_disease_indicators 
-- SELECT * FROM file('path/to/data/chronic_disease_indicators.csv', 'CSVWithNames');

-- Logistics data loading
-- INSERT INTO manufacturing_logistics.supply_chain_operations 
-- SELECT * FROM file('path/to/data/logistics_supply_chain.csv', 'CSVWithNames');

-- ================================================================================
-- SAMPLE QUERIES FOR TESTING
-- ================================================================================

-- E-commerce: Top selling products by revenue
-- SELECT StockCode, Description, sum(TotalAmount) as Revenue, count() as Orders
-- FROM ecommerce_retail.online_retail_transactions 
-- WHERE IsReturn = 0 
-- GROUP BY StockCode, Description 
-- ORDER BY Revenue DESC 
-- LIMIT 10;

-- Finance: Monthly transaction volume by account type
-- SELECT AccountType, TransactionMonth, sum(AbsTransactionAmount) as Volume
-- FROM finance_banking.banking_transactions
-- GROUP BY AccountType, TransactionMonth
-- ORDER BY Volume DESC;

-- Healthcare: Top chronic diseases by state
-- SELECT LocationDesc, Topic, avg(DataValue) as AvgRate
-- FROM healthcare_pharma.chronic_disease_indicators
-- WHERE DataValue IS NOT NULL AND IsStateLevel = 1
-- GROUP BY LocationDesc, Topic
-- ORDER BY AvgRate DESC;

-- Logistics: High risk shipments analysis
-- SELECT Date, count() as TotalShipments, 
--        countIf(IsHighRisk = 1) as HighRiskShipments,
--        (countIf(IsHighRisk = 1) * 100.0 / count()) as RiskPercentage
-- FROM manufacturing_logistics.supply_chain_operations
-- GROUP BY Date
-- ORDER BY Date DESC;

-- Digital Product: Daily active users and sessions
-- SELECT Date, uniqExact(UserID) as DAU, count() as Sessions,
--        avg(SessionDuration) as AvgSessionDuration
-- FROM digital_product.user_sessions
-- GROUP BY Date
-- ORDER BY Date DESC;

-- ================================================================================
-- MATERIALIZED VIEWS FOR ANALYTICS
-- ================================================================================

-- E-commerce daily sales summary
CREATE MATERIALIZED VIEW IF NOT EXISTS ecommerce_retail.daily_sales_summary
ENGINE = SummingMergeTree()
ORDER BY (Date, Country)
AS
SELECT 
    toDate(InvoiceDate) as Date,
    Country,
    count() as OrderCount,
    uniqExact(CustomerID) as UniqueCustomers,
    sum(TotalAmount) as TotalRevenue,
    avg(TotalAmount) as AvgOrderValue
FROM ecommerce_retail.online_retail_transactions
WHERE IsReturn = 0 AND CustomerID IS NOT NULL
GROUP BY Date, Country;

-- Banking monthly customer metrics
CREATE MATERIALIZED VIEW IF NOT EXISTS finance_banking.monthly_customer_metrics
ENGINE = SummingMergeTree()
ORDER BY (YearMonth, AccountType, BranchCode)
AS
SELECT 
    toYYYYMM(TransactionDate) as YearMonth,
    AccountType,
    BranchCode,
    uniqExact(CustomerID) as ActiveCustomers,
    count() as TotalTransactions,
    sum(AbsTransactionAmount) as TransactionVolume,
    avg(AccountBalance) as AvgAccountBalance
FROM finance_banking.banking_transactions
GROUP BY YearMonth, AccountType, BranchCode;

-- Digital product hourly events summary
CREATE MATERIALIZED VIEW IF NOT EXISTS digital_product.hourly_events_summary
ENGINE = SummingMergeTree()
ORDER BY (DateTime, EventType)
AS
SELECT 
    toStartOfHour(Timestamp) as DateTime,
    EventType,
    count() as EventCount,
    uniqExact(UserID) as UniqueUsers,
    uniqExact(SessionID) as UniqueSessions
FROM digital_product.clickstream_events
GROUP BY DateTime, EventType;

-- ================================================================================
-- INDEXES FOR PERFORMANCE
-- ================================================================================

-- Create skip indexes for better query performance
ALTER TABLE ecommerce_retail.online_retail_transactions 
ADD INDEX idx_customer_id CustomerID TYPE bloom_filter GRANULARITY 1;

ALTER TABLE finance_banking.banking_transactions 
ADD INDEX idx_transaction_type TransactionType TYPE set(100) GRANULARITY 1;

ALTER TABLE digital_product.clickstream_events 
ADD INDEX idx_event_type EventType TYPE set(50) GRANULARITY 1;

-- ================================================================================
-- USER ROLES AND PERMISSIONS (Optional)
-- ================================================================================

-- Create read-only role for analysts
-- CREATE ROLE IF NOT EXISTS analyst;
-- GRANT SELECT ON ecommerce_retail.* TO analyst;
-- GRANT SELECT ON finance_banking.* TO analyst;
-- GRANT SELECT ON healthcare_pharma.* TO analyst;
-- GRANT SELECT ON manufacturing_logistics.* TO analyst;
-- GRANT SELECT ON digital_product.* TO analyst;

-- Create data engineer role with write permissions
-- CREATE ROLE IF NOT EXISTS data_engineer;
-- GRANT ALL ON ecommerce_retail.* TO data_engineer;
-- GRANT ALL ON finance_banking.* TO data_engineer;
-- GRANT ALL ON healthcare_pharma.* TO data_engineer;
-- GRANT ALL ON manufacturing_logistics.* TO data_engineer;
-- GRANT ALL ON digital_product.* TO data_engineer;

-- ================================================================================
-- DATA QUALITY CHECKS
-- ================================================================================

-- Create system table for data quality monitoring
CREATE TABLE IF NOT EXISTS system_catalog.data_quality_checks (
    CheckDate Date,
    TableName String,
    CheckType String,
    CheckDescription String,
    ExpectedValue String,
    ActualValue String,
    Status Enum('PASS', 'FAIL', 'WARNING')
) ENGINE = MergeTree()
ORDER BY (CheckDate, TableName);

-- Sample data quality check queries (to be run regularly):
-- INSERT INTO system_catalog.data_quality_checks
-- SELECT 
--     today() as CheckDate,
--     'ecommerce_retail.online_retail_transactions' as TableName,
--     'NULL_CHECK' as CheckType,
--     'CustomerID should not be null for valid transactions' as CheckDescription,
--     '0' as ExpectedValue,
--     toString(countIf(CustomerID IS NULL)) as ActualValue,
--     if(countIf(CustomerID IS NULL) = 0, 'PASS', 'FAIL') as Status
-- FROM ecommerce_retail.online_retail_transactions;

-- ================================================================================
-- END OF SCRIPT
-- ================================================================================

-- This script creates a comprehensive multi-domain dataset catalog in ClickHouse
-- Domains covered: E-commerce/Retail, Finance/Banking, Healthcare/Pharma, 
--                  Manufacturing/Logistics, Digital Product Analytics
--
-- To use this script:
-- 1. Execute the database and table creation statements
-- 2. Load your actual data files using the INSERT examples provided
-- 3. Run the sample queries to verify data and test analytics
-- 4. Use the materialized views for fast aggregated analytics
-- 5. Implement the data quality checks for ongoing monitoring
--
-- Total tables created: 11 main tables + 3 materialized views
-- Total databases: 5 domain-specific databases
-- Features: Optimized for analytics, includes derived columns, proper indexing,
--           partitioning strategies, and sample business intelligence queries