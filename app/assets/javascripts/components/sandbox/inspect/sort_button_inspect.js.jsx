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

    var currentModel = table.state.currentModel;
    var newModels = table.state.models;
    newModels[currentModel].sort = newSort;

    table.setState({ loading: true });
    $.getJSON(table.state.data.url,
      {
        search: table.state.search,
        sort: newSort,
        limit: table.state.limit,
        offset: table.state.offset,
        caseSens: table.state.caseSens,
        fuzzy: table.state.fuzzy,
        current_model: currentModel
      },
      function (newData) {
        table.setState({
          data: newData,
          models: newModels,
          sort: newSort,
          loading: false
        });
      }
    );
  }
});
