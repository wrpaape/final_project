/* globals React */
'use strict';

var QueryInspect = React.createClass({

  render: function() {
    var table = this.props.parent;
    var query = table.state.data.query;
    var coloredQuery = [];
    var keys = Object.keys(query);
    keys.forEach(function (key, i) {
      coloredQuery.push(<span key={ 'query-' + i } className={ key }>{ query[key] }</span>);
    }.bind(this));
    return(
      <div className='query-wrap'>
        { coloredQuery }
      </div>
    );
  }
});
