CREATE TABLE Logs(
 `timestamp` TIMESTAMP(3),
 bci INTEGER,
 event_type STRING,
 user_id STRING
) WITH (
 'connector' = 'kafka',
 'topic' = 'logs',
 'properties.bootstrap.servers' = 'localhost:29092',
 'value.format' = 'json',
 'properties.group.id' = 'logs-reader',
 'scan.startup.mode' = 'earliest-offset'
);

CREATE TABLE Metrics(
 user_id STRING,
 avg_bci INTEGER,
 PRIMARY KEY(user_id) NOT ENFORCED
) WITH (
 'connector' = 'upsert-kafka',
 'topic' = 'metrics',
 'properties.bootstrap.servers' = 'localhost:29092',
 'value.format' = 'json',
 'key.format' = 'json',
 'properties.group.id' = 'metrics-reader'
);

CREATE TABLE SearchSink(
 user_id STRING,
 avg_bci INTEGER,
 PRIMARY KEY(user_id) NOT ENFORCED
) WITH (
 'connector' = 'opensearch',
 'hosts' = 'localhost:9200',
 'index' = 'metrics',
 'allow-insecure' = 'true',
 'username' = 'admin',
 'password' = 'admin'
);
