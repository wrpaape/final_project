/* globals React */
'use strict';

var SortButtonInspect = React.createClass({
  getInitialState: function() {
    return {
      currentModel: this.props.currentModel,
      colName: this.props.colName
    };
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({
      currentModel: nextProps.currentModel
    });
  },
  render: function () {
    var table = this.props.grandparent;
    var currentModel = this.state.currentModel;
    var sort = table.state.models[currentModel].sort;
    var colName = this.state.colName;
    var colRegex = new RegExp(colName + '░');
    var colIndex = sort.search(colRegex);
    var sortDirIndexStart = colIndex + colName.length + 1;
    var afterCol = sort.slice(sortDirIndexStart);
    var sortDirIndexEnd = sortDirIndexStart + afterCol.search('▓');
    var sortDir = sortDirIndexEnd > sortDirIndexStart ? sort.slice(sortDirIndexStart, sortDirIndexEnd) : '';
    var dispName = colName;
    if (sortDir !== '') {
      dispName += ' (' + sortDir + ')';
    }

    return (
      <th id={ currentModel + '-sort-' + colName } key={ currentModel + '-sort-' + colName } data-id={ sortDir } className={ this.props.className } onClick={ this.clicked.bind(this, table, currentModel, colName) }>
        { dispName }
      </th>
    );
  },
  clicked: function (table, currentModel, colName) {
    var idSelector = '#' + currentModel +'-sort-' + colName;
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
      newSort += $(this).attr('id').slice(currentModel.length + 6) + '░' + $(this).attr('data-id') + '▓';
    });

    var newModels = $.extend({}, table.state.models);
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
