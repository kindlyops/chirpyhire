class ZipcodeFetcherJob < ApplicationJob
  def perform(contact, zipcode_string)
    ZipcodeFetcher.call(contact, zipcode_string)
  end
end
