#!/bin/bash
# Apply the controlplane and worker configurations to the controlplane and worker nodes.

CONTROL_PANES=("192.168.0.10" "192.168.0.11" "192.168.0.12")
WORKERS=("192.168.0.13" "192.168.0.14" "192.168.0.15")

for cp in "${CONTROL_PANES[@]}"; do
    echo "Applying controlplane config to $cp"
    talosctl apply-config --insecure --nodes $cp --file conf/controlplane.yaml
done

for w in "${WORKERS[@]}"; do
    echo "Applying worker config to $w"
    talosctl apply-config --insecure --nodes $w --file conf/worker.yaml
done
