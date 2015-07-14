/* globals React */
'use strict';

var SearchBarInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var inputs = [];
    var show = this.state.show;
    var table = this.props.grandparent;
    var currentModel = table.state.currentModel;
    var model = table.state.models[currentModel];
    var caseSens = model.caseSens;
    var fuzzy = model.fuzzy;
    var search = model.search;
    var keys = table.state.data.keys;
    keys.forEach(function(key, i) {

    var keyRegex = new RegExp(key + '░');

    var keyIndex = search.search(keyRegex);
    var searchByIndexStart = keyIndex + key.length + 1;
    var afterCol = search.slice(searchByIndexStart);
    var searchByIndexEnd = searchByIndexStart + afterCol.search('▓');
    var searchBy = searchByIndexEnd > searchByIndexStart ? search.slice(searchByIndexStart, searchByIndexEnd) : '';
      inputs.push(
        <div key={ 'search-' + i } className='search'>
          <label htmlFor={ key }>{ key }&nbsp;</label>
          <SearchInputInspect id={ key } type='text' className='search-input' defaultValue={ searchBy } />
        </div>
      );
    });
    inputs.push(
      <div key={ 'search-submit' } className='search-submit'>
        <div className='label-wrap'>
          <label htmlFor='fuzzy'>fuzzy&nbsp;</label>
          <label htmlFor='case-sens'>case-sensitive&nbsp;</label>
        </div>
        <div className='submit-wrap'>
          <div className='box-wrap'>
            <SearchInputInspect id='fuzzy' type='checkbox' className='' defaultValue={ fuzzy } />
            <SearchInputInspect id='casesens' type='checkbox' className='' defaultValue={ caseSens } />
          </div>
          <input type='submit' value='search' className='submit btn btn-primary' />
        </div>
      </div>
    );

    if (show) {
      return (
        <div data-id={ show } className='wind0w-button wind0w-search search-bar'>
          <div onClick={ this.clicked.bind(this, show, table) } className='btn btn-default show-hide search-button'>Search Bar</div>
          <form onSubmit={ this.submitted }>
            { inputs }
          </form>
        </div>
      );
    } else {
      return(
        <div data-id={ show } onClick={ this.clicked.bind(this, show, table) } className='wind0w-button wind0w-search btn btn-primary show-hide search-button'>
          Search Bar
        </div>
      );
    };
  },
  submitted: function (e) {
    e.preventDefault();
    var table = this.props.grandparent;
    var newSearch = '';
    var keys = table.state.data.keys;
    var searches = $('.search-input');
    var newCaseSens = $('#case-sens').is(":checked") ? 'on' : '';
    var newFuzzy = $('#fuzzy').is(":checked") ? 'on' : '';
    searches.each(function (i) {
      newSearch += keys[i] + '░' + $(this).val() + '▓';
    });

    var currentModel = table.state.currentModel;
    var newModels = $.extend({}, table.state.models);
    newModels[currentModel].search = newSearch;
    newModels[currentModel].offset = 0;
    newModels[currentModel].caseSens = newCaseSens;
    newModels[currentModel].fuzzy = newFuzzy;

    table.setState({ loading: true });
    $.getJSON(table.state.data.url,
      {
        inspect: true,
        search: newSearch,
        sort: table.state.sort,
        limit: table.state.limit,
        offset: 0,
        case_sens: newCaseSens,
        fuzzy: newFuzzy,
        current_model: currentModel
      },
      function (newData) {
        table.setState({
          data: newData,
          models: newModels,
          search: newSearch,
          offset: 0,
          caseSens: newCaseSens,
          fuzzy: newFuzzy,
          loading: false
        });
      }
    );
  },
  clicked: function(show, table) {
    var oldPad = table.state.padding;
    if (oldPad < 285 && !show) {
      table.setState({ padding: 285 });
    } else if (oldPad === 285 && show) {
      table.setState({ padding: 165 });
    }
    this.setState({ show: !show });
  }
});
