resource "google_compute_instance" "couchdb_server" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project

  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/family/${var.os_family}"
      size  = var.disk_size
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {}
  }

  metadata = {
    serial-port-enable = "TRUE"
    windows-startup-script-ps1 = <<-EOF
      $installerUrl = "${var.installer_url}"
      $powershellUrl = "${var.powershell_url}"
      $adminUsername = "${var.admin_username}"
      
      $tempDir = "C:\\Temp"
      if (-Not (Test-Path $tempDir)) { New-Item $tempDir -ItemType Directory }
      
      $scriptPath = "$tempDir\\install_couchdb.ps1"
      Invoke-WebRequest -Uri $powershellUrl -OutFile $scriptPath
      
      & $scriptPath -installerUrl $installerUrl -adminUsername $adminUsername
    EOF
  }

  provisioner "local-exec" {
    command = "gcloud compute reset-windows-password ${self.name} --zone=${var.zone} --project=${var.project} --user=${var.admin_username} --quiet > ${self.name}-pass.txt"
  }
}
