resource "kubernetes_cron_job" "offset_commit" {
  metadata {
    name = "kafka-offset-commit"
  }
  spec {
    schedule                      = "*/1 * * * *"  # Runs every minute
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 1

    job_template {
      spec {
        template {
          spec {
            container {
              name  = "offset-commit"
              image = "your-docker-registry/offset-commit:latest"  # Replace with your actual image
              env {
                name  = "KAFKA_BOOTSTRAP_SERVERS"
                value = aws_msk_cluster.kafka_cluster.bootstrap_brokers_tls
              }
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}
