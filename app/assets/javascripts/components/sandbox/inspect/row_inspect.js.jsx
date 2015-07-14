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
    var wind0wObj = table.state.wind0wObj;
    var wind0wObjModel = table.state.wind0wObjModel;
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

    if (wind0wObj.id === obj.id && wind0wObjModel === currentModel) {
      var className = 'highlight';
    } else {
      var className = '';
    }

    return (
      <tr id={ currentModel + '-' + obj.id } className={ className } onClick={ this.clicked.bind(this, table, obj, wind0wObjModel, currentModel) }>
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
  clicked: function (table, obj, wind0wObjModel, currentModel) {
    var thisId = '#' + currentModel + '-' + obj.id;
    var thisRow = $(thisId);
    var allRows = $('tr');
    allRows.each(function () {
      if ($(this).attr('id') !== wind0wObjModel + '-' + obj.id) {
        $(this).attr('class', '');
      };
    });

    var oldPad = table.state.padding;
    var newPad;
    if (thisRow.attr('class') === '') {
      thisRow.attr('class', 'highlight');
      newPad = $('.wind0w-object').attr('data-id') === 'true' ? 321 : oldPad;
      table.setState({
        wind0wObj: obj,
        wind0wObjModel: currentModel,
        padding: newPad
      });
    } else {
      thisRow.attr('class', '');
      if (oldPad === 25) {
        newPad = 25;
      } else {
        newPad = $('.wind0w-search').attr('data-id') === 'true' ? 285 : 165;
      }
      table.setState({
        wind0wObj: { id: 0 },
        wind0wObjModel: currentModel,
        padding: newPad
      });
    }
  }
});
