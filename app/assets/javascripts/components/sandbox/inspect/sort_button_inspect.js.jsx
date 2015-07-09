/* globals React */
'use strict';

var SortButtonInspect = React.createClass({
  render: function () {
    var colName = this.props.colName;
    return (
      <th id={ 'sort-' + colName } data-id='' className={ this.props.className } onClick={ this.clicked }>
        { colName }
      </th>
    );
  },
  clicked: function () {
    var table = this.props.grandparent;
    table.setState({ loading: true });

    var idSelector = '#sort-' + this.props.colName;
    switch ($(idSelector).attr('data-id')) {
      case '':
        $(idSelector).attr('data-id', 'ASC');
        break;
      case 'ASC':
        $(idSelector).attr('data-id', 'DESC');
        break;
      case 'DESC':
        $(idSelector).attr('data-id', '');
    }

    var newSort = '';
    var all_buttons = $('th');
    all_buttons.each(function () {
      newSort += $(this).html() + '░' + $(this).attr('data-id') + '▓';
    });

    $.getJSON(table.state.data.url,
      {
        search: table.state.search,
        sort: newSort,
        limit: table.state.limit,
        offset: table.state.offset,
        caseSens: table.state.caseSens,
        fuzzy: table.state.fuzzy
      },
      function (newData) {
        table.setState({
          data: newData,
          offset: 0,
          sort: newSort,
          loading: false
        });
      }
    );
  }
});
