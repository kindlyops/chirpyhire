json.id account.id
json.url account.url
json.email account.email
json.hero_pattern_classes account.hero_pattern_classes
json.teams account.teams do |team|
  json.id team.id
  json.name team.name
  json.inbox_id team.inbox.id
end

organization = account.organization

json.organization do
  json.id organization.id
  json.name organization.name
  json.sender_notice organization.sender_notice
  json.certification organization.certification
  json.availability organization.availability
  json.live_in organization.live_in
  json.experience organization.experience
  json.transportation organization.transportation
  json.zipcode organization.zipcode
  json.cpr_first_aid organization.cpr_first_aid
  json.skin_test organization.skin_test
end
