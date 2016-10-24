class FakeStateData
  def state_json(zipcode)
    {
      'type' => 'FeatureCollection',
      'features' => [{
        'type' => 'Feature',
        'properties' => {
          'ZCTA5CE10' => zipcode
        },
        'geometry' => {
          'center' => [0.0, 0.0],
          'coordinates' => []
        }
      }]
    }
  end
end
