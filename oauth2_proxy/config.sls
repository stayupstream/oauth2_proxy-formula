{% from "oauth2_proxy/map.jinja" import oauth2_proxy with context %}

oauth2_proxy_pip:
  pkg.installed:
    - name: {{ oauth2_proxy.pip_pkg }}

toml-python-module:
  pip.installed:
    - name: {{ oauth2_proxy.toml_module }}
    - require:
      - pkg: {{ oauth2_proxy.pip_pkg }}


oauth2_proxy-config:
  file.managed:
    - name: /etc/oauth2_proxy/oauth2_proxy.conf
    - source: {{ oauth2_proxy.tmpl_config }}
    - user: oauth2
    - group: oauth2
    - template: jinja
    {% if oauth2_proxy.service != False %}
    - watch_in:
       - service: oauth2_proxy
    {% endif %}
    - require:
      - pip: {{ oauth2_proxy.toml_module }}
    - require:
      - user: oauth2