/* globals React */
'use strict';

var LimitBarInspect = React.createClass({
  getInitialState: function () {
    return {
      limit: 10
    };
  },
  render: function() {
    return(
      <div className='limit'>
        <label htmlFor='limit'>Show&nbsp;</label>
        <input id='limit' type='text' size= '3' onKeyUp={ this.changed } />
        <label htmlFor='limit'>&nbsp;Rows&nbsp;per&nbsp;Page</label>
      </div>
    );
  },
  changed: function (key) {
    if (key.keyCode === 13) {
      var newLimit = parseInt(key.target.value.trim());
      if (newLimit > 0 && newLimit % 1 === 0) {
        var table = this.props.parent;
        var data = table.state.data;
        var currentModel = table.state.currentModel;
        var newModels = $.extend({}, table.state.models);
        newModels[currentModel].limit = newLimit;

        table.setState({ loading: true });
        $.getJSON(data.url,
          {
            inspect: true,
            search: table.state.search,
            sort: table.state.sort,
            limit: newLimit,
            offset: table.state.offset,
            caseSens: table.state.caseSens,
            fuzzy: table.state.fuzzy,
            current_model: currentModel
          },
          function (newData) {
            table.setState({
              data: newData,
              models: newModels,
              limit: newLimit,
              loading: false
            });
          }
        );
      }
    }
  }
});
