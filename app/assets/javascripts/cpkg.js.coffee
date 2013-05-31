$ ->
  # $('.accordion').hide()
  #$('.accordion-button').click (e) ->
  # e.preventDefault()
  # $(this).parent().find(".accordion:first").toggle()

  # $("#package_depends").on("railsAutocomplete.select", -> (event, data)
  #  /* FIXME: NON FUNZIONA */
  #  $('h1').hide()

 $('#typeahead').typeahead(
    # source can be a function
    source: (query, process) ->
      # this function receives the typeahead object and the query string
      $.ajax(
        dataType: "json"
        url: "/packages/search/?q="+query
        # i'm binding the function here using CoffeeScript syntactic sugar,
        # you can use for example Underscore's bind function instead.
        success: (data) =>
          # data must be a list of either strings or objects
          # data = [{'name': 'Joe', }, {'name': 'Henry'}, ...]
          console.log(data)
          console.log(JSON.parse(data.res))
          names = JSON.parse(data.res).map (p) -> p.name
          process(names)
      )
    # if we return objects to typeahead.process we must specify the property
    # that typeahead uses to look up the display value
    property: "name"
    minLength: 2
  )

