resource "null_resource" "ssh_accesscheck" {
  count = var.ssh_accesscheck = true ? 1 : 0

  connection {
    bastion_host = var.bastion_host

    #host = "52.116.140.31"
    host        = var.target_hosts
    user        = "root"
    private_key = var.ssh_private_key
  }

  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]
  }
}
