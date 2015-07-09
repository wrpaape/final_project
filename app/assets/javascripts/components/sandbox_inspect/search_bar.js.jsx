/* globals React */
'use strict';

var SearchBar = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var inputs = [];
    var table = this.props.grandparent;
    var keys = table.state.data.keys;
    keys.forEach(function(key, i) {
      inputs.push(
        <div key={ 'search-' + i } className='row'>
          <div className='search'>
            <div className='col-md-5 no-pad-right'>
              <label className='pull-right' htmlFor={ key }>{ key }&nbsp;</label>
            </div>
            <div className='col-md-7 no-pad-left'>
              <input id={ key } className='search-input' type='text' />
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
            <input id='fuzzy' type='checkbox' defaultChecked />
            <input id='case-sens' type='checkbox' />
          </div>
          <input type='submit' value='search' className='submit btn btn-primary' />
        </div>
      </div>
    );

    if (show) {
      return (
        <div className='row center search-bar'>
          <div onClick={ this.clicked } className='btn btn-default show-hide'>Hide Search Bar</div>
          <form onSubmit={ this.submitted }>
            { inputs }
          </form>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked } className='btn btn-primary show-hide'>Show Search Bar</div>
        </div>
      );
    };
  },
  submitted: function (e) {
    e.preventDefault();
    var table = this.props.grandparent;
    table.setState({ loading: true });
    var newSearch = '';
    var keys = table.state.data.keys;
    var searches = $('.search');
    var caseSens = $('#case-sens').is(":checked");
    var fuzzy = $('#fuzzy').is(":checked");

    searches.each(function (i) {
      newSearch += keys[i] + '░' + $(this).val() + '▓';
    });

    $.getJSON(table.state.data.url,
      {
        search: newSearch,
        sort: table.state.sort,
        limit: table.state.limit,
        offset: table.state.offset,
        case_sens: caseSens,
        fuzzy: fuzzy
      },
      function (newData) {
        table.setState({
          data: newData,
          offset: 0,
          search: newSearch,
          caseSens: caseSens,
          fuzzy: fuzzy,
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
