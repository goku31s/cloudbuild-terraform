resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-east1"

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = "us-east1"
  node_count = 3

  node_config {
    machine_type = "e2-medium"
  }
}
