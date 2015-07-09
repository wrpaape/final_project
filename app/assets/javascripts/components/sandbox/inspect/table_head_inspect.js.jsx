/* globals React */
'use strict';

var TableHeadInspect = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var keys = table.state.data.keys;
    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'grey' : 'white';
      cols.push(<SortButtonInspect key={ 'sort-' + i } className={ className } colName={ keys[i] } grandparent={ table } />);
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
