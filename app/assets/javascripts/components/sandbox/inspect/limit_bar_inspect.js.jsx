/* globals React */
'use strict';

var LimitBarInspect = React.createClass({
  render: function() {
    return(
      <div>
        <label htmlFor='limit'>Show&nbsp;</label>
        <input id='limit' type='text' size= '3' onKeyUp={ this.changed } />
        <label htmlFor='limit'>&nbsp;RowInspects&nbsp;per&nbsp;Page</label>
      </div>
    );
  },
  changed: function (key) {
    if (key.keyCode === 13) {
      var newLimit = parseInt(key.target.value.trim());
      if (newLimit > 0 && newLimit % 1 === 0) {
        var table = this.props.parent;
        var data = table.state.data;
        table.setState({ loading: true });
        $.getJSON(data.url,
          {
            search: table.state.search,
            sort: table.state.sort,
            limit: newLimit,
            offset: table.state.offset,
            caseSens: table.state.caseSens,
            fuzzy: table.state.fuzzy,
            model: table.state.currentModel
          },
          function (newData) {
            table.setState({
              data: newData,
              limit: newLimit,
              loading: false
            });
          }
        );
      }
    }
  }
});
