class FakeStateData
  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/MethodLength
end
