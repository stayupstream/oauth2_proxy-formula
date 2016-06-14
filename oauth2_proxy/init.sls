{% from "oauth2_proxy/map.jinja" import oauth2_proxy with context %}

include:
  - oauth2_proxy.config
  - supervisor.conf
  - supervisor.service

extend:
  supervisor-service:
    service:
      - watch:
        - file: oauth2_proxy


golang:
  pkg.installed:
    - name: golang

oauth2_proxy:
  file.managed:
    - name: {{ oauth2_proxy.bin_dir }}/{{ oauth2_proxy.source_file }}
    - source:  {{ oauth2_proxy.source_url}}/{{ oauth2_proxy.oa_version }}/{{ oauth2_proxy.source_file }}
    - source_hash: {{ oauth2_proxy.source_hash}}
    - require:
      - pkg: golang
      - file: supervisor-config

extract_oauth:
  cmd.run:
    - cwd: {{ oauth2_proxy.bin_dir }}
    - name: tar -zxvf {{ oauth2_proxy.source_file }} --strip=1
    - require_in:
      - pkg: oauth2_proxy
      - service: supervisor
    - creates: {{ oauth2_proxy.bin_file }}
