# iscsi-tools/terraform

## Outputs
The following outputs are available for your ignition config:

- `iscsiadm`: iscsiadm invoker binary as an ignition file.
- `open_iscsid_unit`: the systemd service unit

## Usage
```
module "iscsi_tools" {
  source = "github.com/utilitywarehouse/iscsi-tools//terraform?ref=master"
}

data "ignition_config" "node" {
  files = [
    module.iscsi_tools.iscsiadm,
  ]
  systemd = [
    module.iscsi_tools.open_iscsid_unit,
  ]
}
```
