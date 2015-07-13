/* globals React */
'use strict';

var SearchBarInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var inputs = [];
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
        <div key={ 'search-' + i } className='row'>
          <div className='search'>
            <div className='col-md-5 no-pad-right'>
              <label className='pull-right' htmlFor={ key }>{ key }&nbsp;</label>
            </div>
            <div className='col-md-7 no-pad-left'>
              <SearchInputInspect id={ key } className='search-input' type='text' defaultValue={ searchBy } />
            </div>
          </div>
        </div>
      );
    });
    inputs.push(
      <div key={ 'search-submit' } className='row search-submit'>
        <div className='col-md-5'>
          <div className='row'>
            <label className='pull-right' htmlFor='fuzzy'>fuzzy&nbsp;</label>
          </div>
          <div className='row'>
            <label className='pull-right' htmlFor='case-sens'>case-sensitive&nbsp;</label>
          </div>
        </div>
        <div className='col-md-offset-5 col-md-7 submit-wrap'>
          <div className='box-wrap'>
            <SearchInputInspect id='fuzzy' className='' type='checkbox' defaultValue={ fuzzy } />
            <SearchInputInspect id='case-sens' className='' type='checkbox' defaultValue={ caseSens } />
          </div>
          <input type='submit' value='search' className='submit btn btn-primary' />
        </div>
      </div>
    );

    if (show) {
      return (
        <div className='row center'>
          <div onClick={ this.clicked } className='btn btn-default show-hide search-button'>Search Bar</div>
          <form onSubmit={ this.submitted }>
            { inputs }
          </form>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked } className='btn btn-primary show-hide search-button'>Search Bar</div>
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
  clicked: function() {
    var oldShow = this.state.show;
    this.setState({ show: !oldShow });
  }
});
