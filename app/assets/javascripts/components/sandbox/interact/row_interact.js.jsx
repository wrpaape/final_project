/* globals React */
'use strict';

var RowInteract = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var obj = this.props.obj;
    var keys = Object.keys(obj);

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker td' : 'lighter td';
      var val = obj[keys[i]];
      var displayVal;
      if (val === null) {
        displayVal = 'nil';
      } else {
        displayVal = val.toString().replace(/\s/g, ' ');
        if (displayVal.length > 48) {
          displayVal = displayVal.slice(0,45) + '...';
          className += ' cropped-text';
        }
      }

      cols.push(<td data-id={ val } id={ 'interact-row-' + obj.id + '-col-' + i } key={ 'row-' + obj.id + '-col-' + i } className={ className } onMouseOver={ this.mouseOver.bind(this, displayVal, val, obj, i) } onMouseOut={ this.mouseOut.bind(this, displayVal, val, obj, i) }>{ displayVal }</td>);
    }
    return (
      <tr id={ obj.id } className={ className }>
        { cols }
      </tr>
    );
  },
  mouseOver: function(displayVal, val, obj, i) {
    var isDatetime = displayVal.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var displayValFormatted = (moment(displayVal).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#interact-row-' + obj.id + '-col-' + i;
      $(idSelector).html(displayValFormatted);
      $(idSelector).addClass('formatted-time');
    } else if (val !== null && val.length > 48) {
      this.timeoutID = window.setTimeout(function() {
        var switchTable = this.props.grandparent;
        var hoveredTextToggle = switchTable.state.hoveredTextToggle;
        var splitLines = val.split('\n');
        var formattedLines = [];
        splitLines.forEach(function(line, j) {
          line = line.length === 0 ? ' ' : line.replace(/\s/g, ' ');
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
      var idSelector = '#interact-row-' + obj.id + '-col-' + i;
      $(idSelector).html(displayVal);
      $(idSelector).removeClass('formatted-time');
    } else if (val !== null && val.length > 48) {
      window.clearTimeout(this.timeoutID);
    }
  }
});
