require "pagy/extras/array"
require "pagy/extras/overflow"

Pagy::DEFAULT[:limit] = 25
Pagy::DEFAULT[:overflow] = :empty_page
