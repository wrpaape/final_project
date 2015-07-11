/* globals React */
'use strict';

var TableHeadInteract = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var keys = Object.keys(table.state.data[0]);

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
