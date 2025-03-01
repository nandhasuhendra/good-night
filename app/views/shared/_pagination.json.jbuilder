json.paginate do
  json.page pagy.page
  json.next_page pagy.next
  json.prev_page pagy.prev
  json.total_page pagy.count
  json.limit pagy.limit
end
