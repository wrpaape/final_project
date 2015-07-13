/* globals React */
'use strict';

var PaginateInspect = React.createClass({
  render: function () {
    var table = this.props.parent;
    var limit = table.state.limit;
    var offset = table.state.offset;
    var lengthData = table.state.data.lengthData;
    var lastPage = Math.ceil((lengthData || 1) / limit);
    var currentPage = Math.ceil(offset / limit) + 1;

    return(
      <div>
        <div onClick={ this.clicked.bind(this, 1, table, lastPage) } className='btn btn-default next-prev'>First</div>
        <div onClick={ this.clicked.bind(this, currentPage - 1, table, lastPage) } className='btn btn-default next-prev'>Prev</div>
        <input className='btn btn-primary next-prev' type='text' size={ currentPage.toString().length } placeholder={ currentPage } onKeyUp={ this.changed } />
        <div onClick={ this.clicked.bind(this, currentPage + 1, table, lastPage) } className='btn btn-default next-prev'>Next</div>
        <div onClick={ this.clicked.bind(this, lastPage, table, lastPage) } className='btn btn-default next-prev'>Last</div>
      </div>
    );
  },
  clicked: function (newPage, table, lastPage) {
    if (newPage > 0 && newPage <= lastPage) {
      var newOffset = (newPage - 1) * table.state.limit;
      var currentModel = table.state.currentModel;
      var newModels = $.extend({}, table.state.models);
      newModels[currentModel].offset = newOffset;
      table.setState({ loading: true });
      $.getJSON(table.state.data.url,
        {
          inspect: true,
          search: table.state.search,
          sort: table.state.sort,
          limit: table.state.limit,
          offset: newOffset,
          case_sense: table.state.caseSens,
          fuzzy: table.state.fuzzy,
          current_model: currentModel
        },
        function (newData) {
          table.setState({
            data: newData,
            models: newModels,
            offset: newOffset,
            loading: false
          });
        }
      );
    }
  },
  changed: function (key) {
    if (key.keyCode === 13) {
      var newPage = parseInt(key.target.value.trim());
      var table = this.props.parent;
      var limit = table.state.limit;
      var lengthData = table.state.data.lengthData;
      var lastPage = Math.ceil((lengthData || 1) / limit);

      if (newPage > 0 && newPage <= lastPage && newPage % 1 === 0) {
        var newOffset = (newPage - 1) * table.state.limit;
        var currentModel = table.state.currentModel;
        var newModels = table.state.models;
        newModels[currentModel].offset = newOffset;

        table.setState({ loading: true });
        $.getJSON(table.state.data.url,
          {
            search: table.state.search,
            sort: table.state.sort,
            limit: table.state.limit,
            offset: newOffset,
            case_sense: table.state.caseSens,
            fuzzy: table.state.fuzzy,
            current_model: currentModel
          },
          function (newData) {
            table.setState({
              data: newData,
              models: newModels,
              offset: newOffset,
              loading: false
            });
          }
        );
      }
    }
  }
});
