/* globals React */
'use strict';

var SelectedObjInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var obj = table.state.wind0wObj;
    var data = table.state.data;
    var model = table.state.currentModel;
    var keysCopy = $.extend([], Object.keys(table.state.wind0wObj));
    var longestLengthKeys = keysCopy.sort(function (a, b) { return b.length - a.length; })[0].length;
    var displayHash = {};
    keysCopy.forEach(function(key) {
      var val = obj[key];
      if (val === null) {
        val =  'nil';
      } else {
        val = val.toString().replace(/\s/g,' ').replace(/(▓@|▓#|▓?|▓&|▓%|▓\*|▓`|▓~|▓)/g, '');
        val = val.length > 48 ? val.slice(0, 45) + '...' : val;
      }
      displayHash[key] = val;
    });
    var displayValues = keysCopy.map(function(key){
      return displayHash[key];
    });
    var longestLengthValues = displayValues.sort(function (a, b) { return b.length - a.length; })[0].length;
    var longestLength = longestLengthKeys + 2 + longestLengthValues;
    var attributes = [];
    attributes.push(<span key='obj-open'>{ '{' }</span>);
    if (obj.id !== 0) {
      var indent = '  ';
      keysCopy.forEach(function(key, i) {
        var diff = longestLengthKeys - key.length;
        var pad = new Array(diff + 1).join(' ') + indent;
        var val = obj[key];
        var displayVal = displayHash[key];
        var className = 'value';
        if (val !== null && val.toString().length > 48) {
          className += ' cropped-text';
        }

        attributes.push(
          <div key={'obj-attr-' + i }>
            <span className='pad'>{ pad }</span>
            <span className='key'>{ key }</span>
            <span>: </span>
            <span data-id={ val } id={ 'row-' + i } className={ className } onMouseOver={ this.mouseOver.bind(this, displayVal, val, i) } onMouseOut={ this.mouseOut.bind(this, displayVal, val, i) }>{ displayVal }</span>
          </div>
        );
      }.bind(this));
    };
    attributes.push(<span key='obj-close'>{ '}' }</span>);

    if (show) {
      return(
        <div>
          <div data-id={ show } onClick={ this.clicked.bind(this, show, obj, table, longestLength) } className='wind0w-button wind0w-object btn btn-default show-hide'>selected object</div>
          <section className='object'>
            { attributes }
          </section>
        </div>
      );
    } else {
      return(
        <div data-id={ show } onClick={ this.clicked.bind(this, show, obj, table, longestLength) } className='wind0w-button wind0w-object btn btn-primary show-hide'>
          selected object
        </div>
      );
    };
  },
  mouseOver: function(displayVal, val, i) {
    var isDatetime = displayVal.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var displayValFormatted = (moment(displayVal).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#row-' + i;
      $(idSelector).html(displayValFormatted);
      $(idSelector).addClass('formatted-time');
    } else if (val !== null && val.toString().length > 48) {
      this.timeoutID = window.setTimeout(function() {
        var switchTable = this.props.greatgrandparent;
        var hoveredTextToggle = switchTable.state.hoveredTextToggle;
        var formattedText = [];
        var splitLines = val.length > 48 ? val.split('\n') : val;
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
            formattedLine.push(<span key={ 'hovered-text-seg-' + k + '-line-' + j } className={ className }>{ seg }</span>);
          });
          formattedText.push(<p key={ 'hovered-text-line-' + j }>{ formattedLine }</p>);
        });
        switchTable.setState({
          hoveredText: formattedText,
          hoveredTextToggle: !hoveredTextToggle
        });
      }.bind(this), 1000);
    }
  },
  mouseOut: function(displayVal, val, i) {
    var isDatetime = val.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var idSelector = '#row-' + i;
      $(idSelector).html(val);
      $(idSelector).removeClass("formatted-time");
    } else if (val !== null && val.toString().length > 48) {
      window.clearTimeout(this.timeoutID);
    }
  },
  clicked: function(show, obj, table, longestLength) {
    var oldPad = table.state.padding;
    var newPad;
    if (!show && obj.id !== 0) {
      newPad = (longestLength + 2) * 7;
    } else if (show) {
      newPad = $('.wind0w-search').attr('data-id') === 'true' ? 285 : 165;
    } else {
      newPad = oldPad;
    }

    table.setState({ padding: newPad });
    this.setState({ show: !show })
  }
});
