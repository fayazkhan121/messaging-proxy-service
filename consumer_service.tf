resource "kubernetes_deployment" "consumer_service" {
  metadata {
    name = "consumer-service-deployment"
    labels = {
      app = "consumer-service"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "consumer-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "consumer-service"
        }
      }
      spec {
        container {
          name  = "consumer-service"
          image = "your-docker-registry/consumer-service:latest"  # Replace with your actual image
          port {
            container_port = 8081
          }
          env {
            name  = "MPS_ENDPOINT"
            value = "http://mps-service"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "consumer_service" {
  metadata {
    name = "consumer-service"
  }
  spec {
    selector = {
      app = "consumer-service"
    }
    port {
      port        = 80
      target_port = 8081
    }
    type = "ClusterIP"
  }
}
