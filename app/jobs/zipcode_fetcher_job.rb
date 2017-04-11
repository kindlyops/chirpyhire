class ZipcodeFetcherJob < ApplicationJob
  def perform(person, zipcode_string)
    ZipcodeFetcher.call(person, zipcode_string)
  end
end
