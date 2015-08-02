/* globals React */
'use strict';

var RowInteract = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var obj = this.props.obj;
    var keys = this.props.firstKeys;

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker td' : 'lighter td';
      var val = obj[keys[i]];
      var displayVal;
      if (val === null) {
        displayVal = 'nil';
      } else {
        displayVal = val.toString().replace(/\s/g, ' ').replace(/(▓@|▓#|▓?|▓&|▓%|▓\*|▓`|▓~|▓)/g, '');
        if (displayVal.length > 48) {
          displayVal = displayVal.slice(0, 45) + '...';
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
        var formattedText = [];
        var splitLines = val.split('\n');
        splitLines.forEach(function(line, j) {
          if (line.length === 0) {
            line = ' ';
          }
          var splitLine = line.replace(/^\s+/, ' ').split('▓');
          var formattedLine = [];
          splitLine.forEach(function(seg, k) {
            var className = '';
            if (k % 2 !== 0) {
              className += 'code ';
              if (seg[0] === '%') {
                className += 'code-general';
              } else if (seg[0] === '?') {
                className += ' code-sql';
              } else if (seg[0] === '#') {
                className += ' code-ar-keyword';
              } else if (seg[0] === '@') {
                className += ' code-table';
              } else if (seg[0] === '&') {
                className += ' code-relation';
              } else if (seg[0] === '*') {
                className += ' code-attribute';
              } else if (seg[0] === '~') {
                className += ' code-model';
              } else if (seg[0] === '`') {
                className += ' code-value';
              }
              seg = seg.slice(1);
            }
            formattedLine.push(<span key={ 'hovered-text-seg-' + obj.id + '-col-' + k + '-line-' + j } className={ className }>{ seg }</span>);
          });
          formattedText.push(<p key={ 'hovered-text-line-' + obj.id + '-line-' + j }>{ formattedLine }</p>);
        });
        switchTable.setState({
          hoveredText: formattedText,
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
