/* globals React */
'use strict';

var RowInspect = React.createClass({
  getInitialState: function() {
    var table = this.props.parent;
    return {
      currentModel: table.state.currentModel,
      obj: this.props.obj
    };
  },
  componentWillReceiveProps: function(nextProps) {
    var table = nextProps.parent;
    this.setState({
      currentModel: table.state.currentModel,
      obj: nextProps.obj
    });
  },
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var currentModel = this.state.currentModel;
    var windowObj = table.state.windowObj;
    var windowObjModel = table.state.windowObjModel;
    var obj = this.state.obj;
    var keys = Object.keys(obj);

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker' : 'lighter';
      var val = obj[keys[i]];

      if (val === null) {
        val = 'nil';
      }

      cols.push(<td id={ 'row-' + obj.id + '-col-' + i } key={ currentModel + '-row-' + obj.id + '-col-' + i } className={ className } onMouseOver={ this.mouseOver.bind(this, val, obj, i) } onMouseOut={ this.mouseOut.bind(this, val, obj, i) }>{ val }</td>);
    }

    if (windowObj.id === obj.id && windowObjModel === currentModel) {
      var className = 'highlight';
    } else {
      var className = '';
    }

    return (
      <tr id={ currentModel + '-' + obj.id } className={ className } onClick={ this.clicked.bind(this, table, obj, windowObjModel, currentModel) }>
        { cols }
      </tr>
    );
  },
  mouseOver: function(val, obj, i) {
    var isDatetime = val.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var valFormatted = (moment(val).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#row-' + obj.id + '-col-' + i;
      $(idSelector).html(valFormatted);
      $(idSelector).addClass("formatted-time");
    }
  },
  mouseOut: function(val, obj, i) {
    var idSelector = '#row-' + obj.id + '-col-' + i;
    $(idSelector).html(val);
    $(idSelector).removeClass("formatted-time");
  },
  clicked: function (table, obj, windowObjModel, currentModel) {
    var thisId = '#' + currentModel + '-' + obj.id;
    var thisRow = $(thisId);
    var allRows = $('tr');
    allRows.each(function () {
      if ($(this).attr('id') !== windowObjModel + '-' + obj.id) {
        $(this).attr('class', '');
      };
    });

    if (thisRow.attr('class') === '') {
      thisRow.attr('class', 'highlight');
      table.setState({
        windowObj: obj,
        windowObjModel: currentModel
      });
    } else {
      thisRow.attr('class', '');
      table.setState({
        windowObj: { id: 0 },
        windowObjModel: currentModel
      });
    }

  }
});
