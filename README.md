# iscsi-tools

This repo contains tools and images to run and support an opinionated open-iscsi
setup on flatcar linux. It's main purpose is to untie iscsi tools from flatcar
images and help us maintain a healthy trident setup.

## Deploy
See [terraform/](./terraform) for a Terraform module that provides ignition
config to deploy an open-iscsid service running inside a docker container and
place the iscsiadm invoker under `/opt/bin/iscsi`

## Trident patch
In order for the above to work we must patch trident-csi daemonset, so that the
custom isciadm binary we deployed takes precedence on the `$PATH` to the native
binary.

For that we will need to patch the respective environment variable:
````
        - name: PATH
          value: /opt/bin/iscsi/:/netapp:/bin
```
and mount hosts `/opt/bin/iscsi` into the trident-main container:
```
        volumeMounts:
        - name: iscsi-bin
          mountPath: /opt/bin/iscsi
      volumes:
      - name: iscsi-bin
        hostPath:
          path: /opt/bin/iscsi
```
