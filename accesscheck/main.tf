locals {
  target_count = var.ssh_accesscheck ? len(var.target_hosts) : 0
}


resource "null_resource" "ssh_accesscheck" {
  count = local.target_count

  connection {
    bastion_host = var.bastion_host

    #host = "52.116.140.31"
    host        = var.target_hosts[count.index]
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
