output "result" {
  value = {
    values = {
      host = "${kubernetes_service.redis.metadata[0].name}.${kubernetes_service.redis.metadata[0].namespace}.svc.cluster.local"
      port = kubernetes_service.spec.port[0].port
      username = ""
    }
    secrets = {
      password = ""
    }
    // UCP resource IDs
    resources = [
        "/planes/kubernetes/local/namespaces/${kubernetes_service.redis.metadata[0].namespace}/providers/core/Service/${kubernetes_service.redis.metadata[0].name}",
        "/planes/kubernetes/local/namespaces/${kubernetes_deployment.redis.metadata[0].namespace}/providers/apps/Deployment/${kubernetes_deployment.redis.metadata[0].name}"
    ]
  }
  description = "The result of the Recipe. Must match the target resource's schema."
  sensitive = true
}
