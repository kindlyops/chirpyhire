json.id account.id
json.url account.url
json.email account.email
json.hero_pattern_classes account.hero_pattern_classes
json.teams account.teams do |team|
  json.id team.id
  json.name team.name
  json.inbox_id team.inbox.id
end
json.organization do
  json.id account.organization.id
  json.name account.organization.name
  json.sender_notice account.organization.sender_notice
end
