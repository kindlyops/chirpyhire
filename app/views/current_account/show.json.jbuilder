json.id account.id
json.url account.url
json.email account.email
json.hero_pattern_classes account.hero_pattern_classes
json.teams account.teams do |team|
  json.id team.id
  json.name team.name
end
