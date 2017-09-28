{% from "oauth2_proxy/map.jinja" import oauth2_proxy with context %}

include:
  - {{ slspath }}.install
  - {{ slspath }}.config
  - {{ slspath }}.service