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
        val = val.toString().replace(/\s/g,' ');
        val = val.length > 48 ? val.slice(0,45) + '...' : val;
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
        var val = displayHash[key];

        attributes.push(
          <div key={'obj-attr-' + i }>
            <span className='pad'>{ pad }</span>
            <span className='key'>{ key }</span>
            <span>: </span>
            <span id={ 'row-' + i } className='value' onMouseOver={ this.mouseOver.bind(this, val, i) } onMouseOut={ this.mouseOut.bind(this, val, i) }>{ val }</span>
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
  mouseOver: function(val, i) {
    var isDatetime = val.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var valFormatted = (moment(val).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#row-' + i;
      $(idSelector).html(valFormatted);
      $(idSelector).addClass("formatted-time");
    }
  },
  mouseOut: function(val, i) {
    var isDatetime = val.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var idSelector = '#row-' + i;
      $(idSelector).html(val);
      $(idSelector).removeClass("formatted-time");
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
