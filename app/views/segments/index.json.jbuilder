json.array! @segments do |segment|
  json.id segment.id
  json.name segment.name
  json.form segment.form
end
