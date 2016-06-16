{% from "oauth2_proxy/map.jinja" import oauth2_proxy with context %}

include:
  - supervisor.service


extend:
  supervisor-service:
    service:
      - watch:
        {% for name, item in salt['pillar.get']('oauth2_proxy:oauth2cfg', {}).items() %}
        - file: {{ oauth2_proxy.conf_dir }}/{{ name }}
        {% endfor %}
        {% if oauth2_proxy.accesscfg %}
        - file: {{ oauth2_proxy.conf_dir }}/{{ oauth2_proxy.accesscfg }}
        {% endif %}
      - require:
        {% for name, item in salt['pillar.get']('oauth2_proxy:oauth2cfg', {}).items() %}
        - file: {{ oauth2_proxy.conf_dir }}/{{ name }}
        {% endfor %}
        {% if oauth2_proxy.accesscfg %}
        - file: {{ oauth2_proxy.conf_dir }}/{{ oauth2_proxy.accesscfg }}
        {% endif %}


{{ oauth2_proxy.conf_dir }}:
  file.directory:
  - user: root
  - group: root
  - dir_mode: 755


{% if oauth2_proxy.accesscfg %}
{{ oauth2_proxy.conf_dir }}/{{ oauth2_proxy.accesscfg }}:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
         # Don't Edit
         # File is managed by Saltstack
         {% for names, mails in salt['pillar.get']('oauth2_proxy:emails', {}).items() -%}
         {{ mails }}
         {% endfor %}
    - require:
      - file: {{ oauth2_proxy.conf_dir }}
    - require_in:
      - cmd: extract_oauth
{% endif %}


{% for name, item in salt['pillar.get']('oauth2_proxy:oauth2cfg', {}).items() %}
{{ name }}:
  file.managed:
    - name: {{ oauth2_proxy.conf_dir }}/{{ name }}.cfg
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: {{ oauth2_proxy.conf_dir }}
    - require_in:
      - cmd: extract_oauth
    - contents: |
         # Don't Edit
         # File is managed by Saltstack
         {% for key, value in item.items() -%}
         {{ key }} = {{ value }}
         {% endfor -%}
{% endfor %}
