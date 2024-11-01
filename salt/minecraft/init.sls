vol-minecraftworlds:
  mount.mounted:
    - name: /mnt/minecraft
    - device: /dev/disk/by-id/scsi-0HC_Volume_100772583
    - fstype: ext4
    - mkmnt: True
    - opts:
      - defaults

jvm-folder:
  file.directory:
    - name: /usr/lib/jvm
    - user: root
    - group: root
    - mode: 755

java:
  archive.extracted:
    - name: /usr/lib/jvm
    - source: https://download.java.net/java/GA/jdk23/3c5b90190c68498b986a97f276efd28a/37/GPL/openjdk-23_linux-x64_bin.tar.gz
    - source_hash: https://download.java.net/java/GA/jdk23/3c5b90190c68498b986a97f276efd28a/37/GPL/openjdk-23_linux-x64_bin.tar.gz.sha256
    - require:
      - file: jvm-folder

java-shell-profile:
  file.managed:
    - name: /etc/profile.d/jdk23.sh
    - contents:
      - export JAVA_HOME=/usr/lib/jvm/jdk-23
      - export PATH=$PATH:$JAVA_HOME/bin
    - user: root
    - group: root
    - mode: 644
    - require:
      - archive: java

minecraft-systemdsrv-file:
  file.managed:
    - name: /etc/systemd/system/minecraft.service
    - contents: |
        [Unit]
        Description=Minecraft Server
        After=network.target

        [Service]
        Sockets=minecraft.socket
        StandardInput=socket
        StandardOutput=journal
        StandardError=journal

        WorkingDirectory=/mnt/minecraft
        ExecStart=/usr/lib/jvm/jdk-23/bin/java -Xmx1024M -Xms1024M -jar minecraft_server.1.21.1.jar nogui
        ExecStop=/bin/echo stop > /var/run/minecraft/systemd.stdin

        [Install]
        WantedBy=multi-user.target
    - user: root
    - group: root
    - mode: 644

minecraft-systemdsock-file:
  file.managed:
    - name: /etc/systemd/system/minecraft.socket
    - contents: |
        [Unit]
        BindsTo=minecraft.service

        [Socket]
        ListenFIFO=/var/run/minecraft/systemd.stdin
        Service=minecraft.service
        SocketUser=root
        SocketGroup=root
        RemoveOnStop=true
        SocketMode=0600
    - user: root
    - group: root
    - mode: 644

minecraft-service:
  service.running:
    - name: minecraft
