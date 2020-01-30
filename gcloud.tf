# Setup gcloud on your system and create the kubeconfig file

resource "null_resource" "configure_gcloud" {
  count = var.google_services.configure_gloud ? 1 : 0
  provisioner "local-exec" {
    when    = create
    command = <<EOT
                gcloud container clusters get-credentials ${google_container_cluster.openwisp_cluster.name} \
                  --region ${google_container_cluster.openwisp_cluster.location} \
                  --project ${var.google_services.project_id}
              EOT
  }
}
