output "api_endpoint" {
  description = "The API service endpoint"
  value       = kubernetes_service.reasons_api.load_balancer_ingress[0].hostname
}