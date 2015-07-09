/* globals React */
'use strict';

var RowInteract = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var windowObj = table.state.windowObj;
    var obj = this.props.obj;
    var keys = this.props.keys;

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'grey' : 'white';
      cols.push(<td key={ 'row-' + obj.id + 'col-' + i } className={ className }>{ obj[keys[i]] }</td>);
    }

    if (windowObj.id === obj.id) {
      var className = 'highlight';
    } else {
      var className = '';
    }

    return (
      <tr id={ obj.id } className={ className } onClick={ this.clicked.bind(this, table, obj) }>
        { cols }
      </tr>
    );
  },
  clicked: function (table, obj) {
    var obj = this.props.obj;
    var thisId = '#' + obj.id;
    var thisRow = $(thisId);
    var allRows = $('tr');
    allRows.each(function () {
      if ($(this).attr('id') !== thisRow.attr('id')) {
        $(this).attr('class', '');
      };
    });

    if (thisRow.attr('class') === '') {
      thisRow.attr('class', 'highlight');
      table.setState({ windowObj: obj });
    } else {
      thisRow.attr('class', '');
      table.setState({ windowObj: { id: 0 } });
    }

  }
});
