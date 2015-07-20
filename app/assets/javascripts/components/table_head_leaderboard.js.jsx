/* globals React */
'use strict';

var TableHeadLeaderboard = React.createClass({
  render: function () {
    var cols = [];
    var keys = this.props.colNames;
    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker' : 'lighter';
      cols.push(<th key={ 'table-head-' + i } className={ className }>{ keys[i] }</th>);
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
