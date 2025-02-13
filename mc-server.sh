#!/bin/bash

set -euo pipefail

get_ip () {
    salt-cloud -f list_nodes hetzner --output yaml | yq -r '."hetzner-cloud-config".hetzner.mc1.public_ips.ipv4'
}

case $1 in
  create)
    salt-cloud -p mc-inst mc1
    IP=$(get_ip)
    ssh-keygen -f ~/.ssh/known_hosts -R "$IP"
    while ! ssh -o UpdateHostKeys=true -o StrictHostKeyChecking=false root@$IP true 2>/dev/null; do
      echo -n .; sleep 1
    done
    ./create-roster.sh
    salt-ssh mc1 state.apply
    echo "IP ist $IP"

  ;;
  destroy)
    IP=$(get_ip)
    ssh $IP -l root systemctl stop minecraft.service
    salt-cloud -yd mc1
    hcloud volume detach minecraftworlds
    ssh-keygen -f ~/.ssh/known_hosts -R "$IP"

  ;;
  *)
    echo "either create or destroy a Minecraft server ... "
    exit 1
  ;;
esac
