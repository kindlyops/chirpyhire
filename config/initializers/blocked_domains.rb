blocked_domains_path = Rails.root.join('config', 'blocked_domains.yml')
blocked_domains = YAML.load_file(blocked_domains_path)
BLOCKED_DOMAINS = /#{blocked_domains.map { |d| Regexp.quote(d) }.join('|')}/
