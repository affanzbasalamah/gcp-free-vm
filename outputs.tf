output "external_ip" {
  description = "External IP address of the free VM"
  value       = google_compute_instance.free_vm.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "Command to SSH into the VM via gcloud"
  value       = "gcloud compute ssh free-vm --zone=${var.zone}"
}
