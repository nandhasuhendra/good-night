json.data do
  json.partial! partial: "sleep_record", collection: @sleep_histories, as: :result
end

json.partial! partial: "shared/pagination", pagy: @pagy
