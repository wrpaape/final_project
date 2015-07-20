/* globals React */
'use strict';

var QueryInspect = React.createClass({

  render: function() {
    var table = this.props.parent;
    var query = table.state.data.query;
    var coloredQuery = [];
    var keys = Object.keys(query);
    keys.forEach(function (key, i) {
      var formattedLine = [];
      var line = query[key];
      if (line !== null) {
        var splitLine = line.split('|');
        splitLine.forEach(function(seg, j) {
          var className = 'code ';
          if (j % 2 !== 0) {
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
          } else {
            className += 'code-general';
          }
          formattedLine.push(<span key={ 'query-seg-' + j } className={ className }>{ seg }</span>);
        });
      }
      coloredQuery.push(<span key={ 'query ' + i }>{ formattedLine }</span>);
    }.bind(this));
    return(
      <div className='query-wrap'>
        { coloredQuery }
      </div>
    );
  }
});
