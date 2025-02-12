resource "confluent_kafka_topic" "dlq_topic" {
  topic_name       = "dlq-topic"
  partitions_count = 3
  # replication_factor is managed by the Kafka broker configuration or the provider’s defaults.
}
