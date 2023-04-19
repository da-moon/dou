
resource "null_resource" "packer" {
  triggers = var.triggers

  provisioner "local-exec" {
    command = <<EOF
CMD_ID=$(aws ssm send-command \
  --document-name "AWS-RunShellScript" \
  --document-version "1" \
  --targets '[{"Key":"InstanceIds","Values":["${var.instance_id}"]}]' \
  --parameters '{"workingDirectory":["/"],"executionTimeout":["3600"],"commands":${jsonencode(var.commands)}}' \
  --timeout-seconds 600 \
  --max-concurrency "50" \
  --max-errors "0" \
  --region ${var.region} | jq -r '.Command.CommandId')

STATUS=$(aws ssm get-command-invocation --command-id $CMD_ID --instance-id ${var.instance_id} | jq -r '.Status')
while [ $STATUS = "InProgress" ] ; do
  sleep 2
  STATUS=$(aws ssm get-command-invocation --command-id $CMD_ID --instance-id ${var.instance_id} | jq -r '.Status')
done

echo "==> Command stdout:"
aws ssm get-command-invocation --command-id $CMD_ID --instance-id ${var.instance_id} | jq -r '.StandardOutputContent'
echo "==> Command stderr:"
aws ssm get-command-invocation --command-id $CMD_ID --instance-id ${var.instance_id} | jq -r '.StandardErrorContent'

EXIT_CODE=$(aws ssm get-command-invocation --command-id $CMD_ID --instance-id ${var.instance_id} | jq -r '.ResponseCode')
exit $EXIT_CODE
EOF
  }
}
