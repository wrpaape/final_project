/* globals React */
'use strict';

var TableHeadInspect = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var keys = table.state.data.keys;
    var currentModel = table.state.currentModel;

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker' : 'lighter';
      cols.push(<SortButtonInspect key={ currentModel + '-sort-' + i } className={ className } colName={ keys[i] } grandparent={ table } currentModel={ table.state.currentModel } />);
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
