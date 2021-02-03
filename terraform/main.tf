variable "release_version" {
  default = "2.1.2"
}

data "ignition_systemd_unit" "open_iscsid" {
  name    = "open-iscsid.service"
  content = <<EOS
[Unit]
Description=Open-iSCSI
Documentation=man:iscsid(8) man:iscsiuio(8) man:iscsiadm(8)
After=network.target NetworkManager-wait-online.service iscsid-initiatorname.service iscsiuio.service tgtd.service targetcli.service

[Service]
ExecStartPre=/usr/sbin/modprobe iscsi_tcp
ExecStartPre=-/bin/sh -c "docker pull quay.io/utilitywarehouse/open-iscsi-alpine:${var.release_version}"
ExecStartPre=-/bin/sh -c 'docker rm "$(docker ps -q --filter=name=open_iscsid)"'
ExecStart=/bin/sh -c "\
    docker run --rm \
    --privileged \
    --net=host \
    -v /etc/iscsi/:/etc/iscsi/ \
    -v /run/lock/iscsi/:/run/lock/iscsi/ \
    --name=open_iscsid \
    quay.io/utilitywarehouse/open-iscsi-alpine:${var.release_version} -f"
ExecStop=docker stop open_iscsid
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOS
}

data "ignition_file" "iscsiadm" {
  mode       = 493
  filesystem = "root"
  path       = "/opt/bin/iscsi/iscsiadm"

  source {
    source = "https://github.com/utilitywarehouse/iscsi-tools/releases/download/${var.release_version}/iscsiadm_${var.release_version}_linux_amd64"
  }
}

output "iscsiadm" {
  value = data.ignition_file.iscsiadm.rendered
}

output "open_iscsid_unit" {
  value = data.ignition_systemd_unit.open_iscsid.rendered
}

