resource "kubernetes_deployment" "mps" {
  metadata {
    name = "mps-deployment"
    labels = {
      app = "mps"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "mps"
      }
    }
    template {
      metadata {
        labels = {
          app = "mps"
        }
      }
      spec {
        container {
          name  = "mps"
          image = "your-docker-registry/mps:latest"  # Replace with your actual image
          port {
            container_port = 8080
          }
          env {
            name  = "KAFKA_BOOTSTRAP_SERVERS"
            value = aws_msk_cluster.kafka_cluster.bootstrap_brokers_tls
          }
          env {
            name  = "MAX_BUFFER_SIZE"
            value = "1000"
          }
          env {
            name  = "POLL_INTERVAL_MS"
            value = "300000"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mps_service" {
  metadata {
    name = "mps-service"
  }
  spec {
    selector = {
      app = "mps"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
