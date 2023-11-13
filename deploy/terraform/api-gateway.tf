provider "kubernetes" {
  # Configuration for your Kubernetes cluster
}

resource "kubernetes_config_map" "api_gateway_configmap" {
  metadata {
    name = "api-gateway-configmap"
  }

  data = {
    API_GATEWAY_HOST:        "0.0.0.0"
    API_GATEWAY_PORT:        "5000"
    AUTH_SERVICE_URL:        "http://user-service:5000"
    USER_SERVICE_URL:        "http://user-service:5000"
    RESTAURANT_SERVICE_URL:  "http://restaurant-service:5000"
  }
}


resource "kubernetes_secret" "api_gateway_secret" {
  metadata {
    name = "api-gateway-secret"
  }

  string_data = {
    JWT_AT_SECRET      = "AtSecret"
    JWT_RT_SECRET      = "RtSecret"
    JWT_AT_EXPIRES_IN  = "15m"
    JWT_RT_EXPIRES_IN  = "7d"
  }

  type = "Opaque"
}


resource "kubernetes_deployment" "api_gateway_deployment" {
  metadata {
    name = "api-gateway-deployment"
    labels = {
      app = "api-gateway"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api-gateway"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = 3
      }
    }

    template {
      metadata {
        labels = {
          app = "api-gateway"
        }
      }

      spec {
        container {
          name  = "api-gateway"
          image = "ragdoll888/humf-api-gateway:v1.0.1"

          ports {
            container_port = 5000
          }

          env {
            name = "SOME_ENV_VARIABLE"
            value_from {
              config_map_key_ref {
                name = "api-gateway-configmap"
                key  = "specific-key"
              }
            }
          }

          env {
            name = "ANOTHER_ENV_VARIABLE"
            value_from {
              secret_key_ref {
                name = "api-gateway-secret"
                key  = "secret-key"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "api_gateway_service" {
  metadata {
    name = "api-gateway"
  }

  spec {
    selector = {
      app = "api-gateway"
    }

    type = "ClusterIP"

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5000
    }
  }
}
