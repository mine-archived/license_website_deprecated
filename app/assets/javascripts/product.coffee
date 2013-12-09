$(document).ready ->
  $button = $('td button')
  $button.click (event, data) ->
    productId = $(this).data('product-id')
