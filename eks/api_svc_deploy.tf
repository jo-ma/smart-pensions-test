/* 
  Kubernetes service manifest for the API
  Provisions an AWS classic load balancer in the public subnet of the EKS VPC
*/
resource "kubernetes_service" "reasons_api" {
  depends_on = [module.eks, aws_db_instance.db]
  metadata {
    name = "${var.api_service_name}-svc"
    labels = {
      app     = var.app_name
      env     = var.env
      service = var.api_service_name
    }
  }
  spec {
    selector = {
      app     = var.app_name
      env     = var.env
      service = var.api_service_name
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

/*
  Kubernetes deployment manifest for the API
  Configured to deploy 3 replicas
*/
resource "kubernetes_deployment" "reasons-api" {
  depends_on = [module.eks, aws_db_instance.db]
  metadata {
    name = "${var.api_service_name}-deploy"
  }
  spec {
    selector {
      match_labels = {
        app     = var.app_name
        env     = var.env
        service = var.api_service_name
      }
    }
    replicas = 3
    template {
      metadata {
        labels = {
          app     = var.app_name
          env     = var.env
          service = var.api_service_name
        }
      }
      spec {
        container {
          name  = var.api_service_name
          image = var.app_image
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "0.25"
              memory = "256Mi"
            }
          }
          port {
            container_port = 8080
          }
          env {
            name  = "DB"
            value = var.db
          }
          env {
            name  = "DB_HOST"
            value = aws_db_instance.db.address
          }
          env {
            name  = "DB_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "DB_USER"
            value = var.db_username
          }
        }
      }
    }
  }
}