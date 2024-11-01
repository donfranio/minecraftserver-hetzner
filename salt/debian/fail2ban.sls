fail2ban-pkgs:
  pkg.installed:
    - pkgs:
      - python3-systemd
      - fail2ban

fail2ban-conf:
  ini.options_present:
    - separator: '='
    - sections:
        DEFAULT:
          backend: systemd
    - name: /etc/fail2ban/jail.d/defaults-debian.conf
