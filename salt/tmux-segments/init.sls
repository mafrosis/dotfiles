{% for segment_name, colours in pillar.get('custom_segments', {}).iteritems() %}
{{ segment_name}}-segment-file:
  file.managed:
    - name: /home/{{ pillar['login_user'] }}/tmux-powerline/segments/{{ segment_name }}.sh
    - source: salt://tmux-segments/{{ segment_name }}.sh
    - user: {{ pillar['login_user'] }}
    - group: {{ pillar['login_user'] }}
    - onlyif: test -d /home/{{ pillar['login_user'] }}/tmux-powerline
    - mode: 770
{% endfor %}
