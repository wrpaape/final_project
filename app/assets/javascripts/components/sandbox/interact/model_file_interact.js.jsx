/* globals React */
'use strict';

var ModelFileInteract = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var data = table.state.data;
    var schema = data.schema;
    var fileName = schema.split('"')[1].slice(0,-1) + '.rb';
    var file = data.model;
    var paddedFile = padFile(file);

    if (show) {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>Hide { fileName }</div>
          <section className='model'>
            { paddedFile }
          </section>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>Show { fileName }</div>
        </div>
      );
    };
    function padFile(file) {
      var paddedFile = [];
      var lines = file.split('\n');
      for (var i = 1; i <= lines.length - 2; i++) {
        if (i === 1 || i === lines.length - 2) {
          paddedFile.push(<span key={ 'file-line-' + i }>{ lines[i] }<br /></span>);
        } else {
          paddedFile.push(<span key={ 'file-line-' + i }><span className='pad'>..</span>{ lines[i] }<br /></span>);
        }
      }
      return paddedFile;
    }
  },
  clicked: function(show) {
    this.setState({ show: !show });
  }
});
