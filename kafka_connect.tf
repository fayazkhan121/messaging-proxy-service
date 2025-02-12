resource "kubernetes_deployment" "kafka_connect" {
  metadata {
    name = "kafka-connect-deployment"
    labels = {
      app = "kafka-connect"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka-connect"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka-connect"
        }
      }
      spec {
        container {
          name  = "kafka-connect"
          image = "your-docker-registry/kafka-connect:latest"  # Replace with your actual image
          port {
            container_port = 8083
          }
          env {
            name  = "KAFKA_BOOTSTRAP_SERVERS"
            value = aws_msk_cluster.kafka_cluster.bootstrap_brokers_tls
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka_connect" {
  metadata {
    name = "kafka-connect-service"
  }
  spec {
    selector = {
      app = "kafka-connect"
    }
    port {
      port        = 80
      target_port = 8083
    }
    type = "ClusterIP"
  }
}
