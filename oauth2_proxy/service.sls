{%- from slspath+"/map.jinja" import oauth2_proxy with context -%}

oauth2_proxy-init-file:
  file.managed:
    {%- if salt['test.provider']('service') == 'systemd' %}
    - source: salt://{{ slspath }}/files/oauth2_proxy.service
    - name: /etc/systemd/system/oauth2_proxy.service
    - mode: 0644
    {%- endif %}

{%- if oauth2_proxy.service %}

oauth2_proxy-service:
  service.running:
    - name: oauth2_proxy
    - enable: True
    - watch:
      - file: oauth2_proxy-init-file

{%- endif %}
