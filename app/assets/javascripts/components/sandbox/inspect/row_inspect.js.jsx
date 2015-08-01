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
    var keysCopy = $.extend([], keys);
    var longestLengthKeys = keysCopy.sort(function (a, b) { return b.length - a.length; })[0].length;
    var displayHash = {};
    keysCopy.forEach(function(key) {
      var val = obj[key];
      if (val === null) {
        val = 'nil';
      } else {
        val = val.toString().replace(/\s/g, ' ');
        val = val.length > 48 ? val.slice(0, 45) + '...' : val;
      }
      displayHash[key] = val;
    });
    var displayValues = keysCopy.map(function(key){
      return displayHash[key];
    });
    var longestLengthValues = displayValues.sort(function (a, b) { return b.length - a.length; })[0].length;
    var longestLength = longestLengthKeys + 2 + longestLengthValues;
    var objPad = (longestLength + 2) * 7;

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker td' : 'lighter td';
      var val = obj[keys[i]];
      var displayVal = displayHash[keys[i]];
      if (val !== null && val.length > 48) {
        className += ' cropped-text';
      }

      cols.push(<td data-id={ val } id={ 'inspect-row-' + obj.id + '-col-' + i } key={ currentModel + '-row-' + obj.id + '-col-' + i } className={ className } onMouseOver={ this.mouseOver.bind(this, displayVal, val, obj, i) } onMouseOut={ this.mouseOut.bind(this, displayVal, val, obj, i) }>{ displayVal }</td>);
    }

    var className = '';
    if (wind0wObj.id === obj.id && wind0wObjModel === currentModel) {
      className += 'highlight';
    }

    return (
      <tr id={ currentModel + '-' + obj.id } className={ className } onClick={ this.clicked.bind(this, table, obj, wind0wObjModel, currentModel, objPad) }>
        { cols }
      </tr>
    );
  },
  mouseOver: function(displayVal, val, obj, i) {
    var isDatetime = displayVal.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var displayValFormatted = (moment(displayVal).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#inspect-row-' + obj.id + '-col-' + i;
      $(idSelector).html(displayValFormatted);
      $(idSelector).addClass('formatted-time');
    } else if (val !== null && val.length > 48) {
      this.timeoutID = window.setTimeout(function() {
        var switchTable = this.props.grandparent;
        var hoveredTextToggle = switchTable.state.hoveredTextToggle;
        var splitLines = val.split('\n');
        var formattedLines = [];
        splitLines.forEach(function(line, j) {
          line = line.length === 0 ? ' ' : line.replace(/^\s+/, new Array(line.search(/[^\s]/) + 1).join(' '));
          formattedLines.push(<p key={'hovered-text-' + obj.id + '-col-' + i + '-line-' + j }>{ line }</p>)
        })
        switchTable.setState({
          hoveredText: formattedLines,
          hoveredTextToggle: !hoveredTextToggle
        });
      }.bind(this), 1000);
    }
  },
  mouseOut: function(displayVal, val, obj, i) {
    var isDatetime = displayVal.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var idSelector = '#inspect-row-' + obj.id + '-col-' + i;
      $(idSelector).html(displayVal);
      $(idSelector).removeClass('formatted-time');
    } else if (val !== null && val.length > 48) {
      window.clearTimeout(this.timeoutID);
    }
  },
  clicked: function (table, obj, wind0wObjModel, currentModel, objPad) {
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
      var clicked = $('.wind0w-object').attr('data-id');
      newPad = clicked === 'true' ? objPad : oldPad;
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
