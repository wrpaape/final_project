/* globals React */
'use strict';

var TableHeadLeaderboard = React.createClass({
  render: function () {
    var cols = [];
    var keys = ['name', 'time to execute', 'solution', 'breakdown', 'datetime submitted'];
    for (var i = 0; i < keys.length; i++) {
      cols.push(<th key={ 'table-head-' + i }>{ keys[i] }</th>);
    }
    return(
      <thead>
        <tr>
          { cols }
        </tr>
      </thead>
    );
  }
});
