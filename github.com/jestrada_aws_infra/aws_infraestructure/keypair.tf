resource "aws_key_pair" "mykey" {
  key_name   = "${var.project_name}-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC61ngABuFBB0RFzKLcWZ+B8ojyBxT1AWDc4MDIAfDhEEcKf4WYjp1dr5zJOkQvEvzVrTf7qcDJccFm/Fg++Bmy9QakauNiJLLztOMJ6J7LjBIp9OYpb98S8WjPpB340NSC+EgqB/X3r6LA7Yz4tDm6/1fwyReflcdv7oy/RQIhZ3qgh2yTRboldQAjR9yPydLAlvBvv2Y9L09sjAcufh14isen57C6OMcYj1L6RvcGClUa5SuKrIwcXq68qMqoFbhuf5vutgtqrELpGELKTASwenF/62Zw/m5KAkFPgr7Ncw+GWZfNhfEz5b0ZE7GLDqChFONs84kYcqbtbJx+Fwavh9tx1wDH+oIhyX0D2TeWks1yaJgAgVNjvgnwD5WKmj502/KEKp41BaHrR2v3YAY8A4MLahi74ijRCltjf+FmveyI9kfTvemCTinzeaMyblwD/UMg77FHbZeTTzZe0BZK6lSG6JpfRDRivwA6Ab/YmTxLNrKejp43N+Wc34pg4Zk= User@DESKTOP-2LJQLKH"
}
