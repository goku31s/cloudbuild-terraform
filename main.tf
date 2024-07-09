resource "google_container_cluster" "mygke" {
  name = "my-gke-cluster"
  location = "us-east1"
  network_policy {
    enabled = true
  }
  node_pool {
    name = "default-pool"
    node_count = 1
    node_config {
      machine_type = "e2-medium"
      disk_size_gb = 20
    }
  }
}
