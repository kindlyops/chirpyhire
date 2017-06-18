json.array! @team_inboxes do |inbox|
  json.id inbox.id
  json.name inbox.team.name
end
