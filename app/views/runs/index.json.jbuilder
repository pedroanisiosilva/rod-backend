json.array!(@runs) do |run|
  json.extract! run, :id, :datetime, :distance, :duration
  json.url run_url(run, format: :json)
end
