/* globals React */
'use strict';

var SelectedObj = React.createClass({
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
    var model = data.model;
    var types = data.types;
    var keysCopy = $.extend( [], data.keys);

    var attributes = [];
    attributes.push(<span key='obj-open'>{ '{' }</span>);
    if (obj.id !== 0) {
      var indent = '.....';
      var longestLength = keysCopy.sort(function (a, b) { return b.length - a.length; })[0].length;
      keysCopy.forEach(function(key, i) {
        var diff = longestLength - key.length;
        var pad = new Array(diff + 1).join('.') + indent;
        attributes.push(
          <div key={'obj-attr-' + i } className='row'>
            <span className='pad'>{ pad }</span>
            <span className='key'>{ key }</span>
            <span>: </span>
            <span className='value'>{ obj[key] }</span>
          </div>
        );
      });
    };
    attributes.push(<span key='obj-close'>{ '}' }</span>);

    if (show) {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>Hide Selected Object</div>
          <section className='object'>
            { attributes }
          </section>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>Show Selected Object</div>
        </div>
      );
    };
  },
  clicked: function(show) {
    this.setState({ show: !show });
  }
});
