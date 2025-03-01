json.data do
  json.partial! partial: "api/v1/user/user", collection: @followings, as: :user
end

json.partial! partial: "shared/pagination", pagy: @pagy
