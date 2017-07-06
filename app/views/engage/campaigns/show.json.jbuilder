json.id @campaign.id
json.name @campaign.name
json.bot_campaign do
  json.id @campaign.bot_campaign.id
  json.inbox_id @campaign.bot_campaign.inbox_id
  json.bot_id @campaign.bot_campaign.bot_id
  json.campaign_id @campaign.bot_campaign.campaign_id
end
