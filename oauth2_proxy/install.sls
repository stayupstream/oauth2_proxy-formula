{% from "oauth2_proxy/map.jinja" import oauth2_proxy with context %}

oauth2_proxy-bin-dir:
  file.directory:
    - name: /usr/local/bin
    - makedirs: True

# Create oauth2 user
oauth2_proxy-user:
  group.present:
    - name: oauth2
  user.present:
    - name: oauth2
    - createhome: false
    - system: true
    - groups:
      - oauth2
    - require:
      - group: oauth2

# Create config directory
oauth2_proxy-config-dir:
  file.directory:
    - name: /etc/oauth2_proxy
    - user: oauth2
    - group: oauth2


# Install oauth2_proxy
oauth2_proxy-download:
  archive.extracted:
    - name: /tmp
    - source: {{ oauth2_proxy.download_url }}{{oauth2_proxy.version}}/{{oauth2_proxy.download_file}}.tar.gz
    - archive_format: tar
    - skip_verify: true
    - keep_source: true
    - if_missing: /usr/local/bin/oauth2_proxy-{{ oauth2_proxy.version }}

oauth2_proxy-install:
  file.rename:
    - name: /usr/local/bin/oauth2_proxy-{{ oauth2_proxy.version }}
    - source: /tmp/{{oauth2_proxy.download_file}}/oauth2_proxy
    - require:
      - file: /usr/local/bin
    - watch:
      - archive: oauth2_proxy-download

oauth2_proxy-clean:
  file.absent:
    - name: /tmp/{{oauth2_proxy.download_file}}
    - watch:
      - file: oauth2_proxy-install

oauth2_proxy-link:
  file.symlink:
    - target: oauth2_proxy-{{ oauth2_proxy.version }}
    - name: /usr/local/bin/oauth2_proxy
    - watch:
      - file: oauth2_proxy-install
