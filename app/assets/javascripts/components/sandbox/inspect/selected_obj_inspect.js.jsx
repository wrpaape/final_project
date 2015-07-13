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
    var obj = table.state.windowObj;
    var data = table.state.data;
    var model = table.state.currentModel;
    var keysCopy = $.extend([], Object.keys(table.state.windowObj));

    var attributes = [];
    attributes.push(<span key='obj-open'>{ '{' }</span>);
    if (obj.id !== 0) {
      var indent = '~~~~~';
      var longestLength = keysCopy.sort(function (a, b) { return b.length - a.length; })[0].length;
      keysCopy.forEach(function(key, i) {
        var diff = longestLength - key.length;
        var pad = new Array(diff + 1).join('~') + indent;
        var val = obj[key];
        if (val === '') {
          val = 'nil';
        }

        attributes.push(
          <div key={'obj-attr-' + i } className='row'>
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
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>Selected Object</div>
          <section className='object'>
            { attributes }
          </section>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>Selected Object</div>
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
    var idSelector = '#row-' + i;
    $(idSelector).html(val);
    $(idSelector).removeClass("formatted-time");
  },
  clicked: function(show) {
    this.setState({ show: !show });
  }
});
