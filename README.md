# Salt-Cloud

## Cheat-Sheet

Roster aus hetzner-API erzeugen:
```
salt-cloud -f list_nodes hetzner --output yaml | yq -y '."hetzner-cloud-config".hetzner | to_entries | map(select( .value.state == "running")) | from_entries | with_entries(.value = { host: .value.public_ips.ipv4 })' > config/roster
´´´
```

## Minecraft-Server

### Anschalten

```
cd ~/Software/salt-cloud
salt-cloud -p mc-inst mc1
IP=$(salt-cloud -f list_nodes hetzner --output yaml | yq -r '."hetzner-cloud-config".hetzner.mc1.public_ips.ipv4')
ssh-keygen -f "~/.ssh/known_hosts" -R "$IP"
while ! ssh -o UpdateHostKeys=true -o StrictHostKeyChecking=false root@$IP true 2>/dev/null; do echo -n .; sleep 1; done
./create-roster.sh
salt-ssh mc1 state.apply
echo "IP ist $IP"
```

### Aussschalten
salt-cloud -yd mc1
hcloud volume detach minecraftworlds
ssh-keygen -f "~/.ssh/known_hosts" -R "$IP"
