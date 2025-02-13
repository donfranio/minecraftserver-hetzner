# Minecraft-Server

Dieses Repo soll es ermöglichen und vereinfachen, einen Minecraft-Server bei
hetzner zu erzeugen, eine Minecraft-Welt von einem volume einzubinden und den
Minecraft-Server-Prozess zu starten.

Nach Gebrauch des Servers kann er wieder gelöscht werden, sodass er keine
weiteren Kosten verursacht, und beim nächsten Bedarf mit der selben Welt wieder
gestartet werden.

## Voraussetzungen

1. Installation von salt-cloud und salt-ssh, siehe
   [saltstack](https://docs.saltproject.io/)
1. Installation von [hcloud-cli](https://github.com/hetznercloud/cli)
1. funktionierender Zugang zu Ressourcen bei [Hetzner GmbH](https://www.hetzner.com/cloud/)
1. API-Key von hetzner
1. SSH-Key bei hetzner nochgeladen
1. Linux-mountable volume in hetzner-Cloud
    1. mit minecraft-server.jar unter korrektem Namen (siehe state für
       Systemd-File in salt/minecraft/init.sls)
    1. mit eula.txt und entsprechendem Inhalt zu Akzeptieren des Lizenzvertrags

## Vorbereiten

1. Dieses Verzeichnis vorzugsweise nach `~/Software/salt-cloud` clonen.
1. Key und Name des SSH-Keys (siehe hetzner WUI) in
   config/cloud.provider.d/hetzner.conf eintragen.

## Anschalten

```
./mc-server create
```

## Aussschalten

```
./mc-server destroy
```
