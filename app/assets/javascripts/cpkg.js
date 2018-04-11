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
      url: $('#typeahead').attr('data-searchpath') + "&q=%QUERY",
      wildcard: '%QUERY',
      transform: function (response) {
        return $.map($.parseJSON(response.res), function (package) {
          return { value: package.name };
        });
      }
    }
  });
  $('#typeahead').typeahead(null, {
    limit: 30, 
    display: 'value',
    source: packages
    //minLength: 3
  });
});

