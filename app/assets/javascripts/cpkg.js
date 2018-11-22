// data = [{'name': 'Joe', }, {'name': 'Henry'}, ...]
// see http://jsfiddle.net/Fresh/bbzt9hcr/
datumTokenizer = function(datum) {
  console.log(datum);
}
$(function() {
  packages = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: $('#typeahead').attr('data-searchpath') + "?q=%QUERY",
      wildcard: '%QUERY',
      transform: function (response) {
        return $.map($.parseJSON(response.res), function (package) {
          // singolo package = { id: 83588, name: "thunderbird-locale-en-gb" }
          return { value: package.name };
        });
      }
    }
  });
  // see real limit in app/controllers/packages_controller.rb
  $('#typeahead').typeahead({}, {
    limit: 100, 
    display: 'value', // see Bloodhound above
    source: packages  // see Bloodhound above
    //minLength: 3
  });
});

