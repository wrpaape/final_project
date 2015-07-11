/* globals React */
'use strict';

var ModelFileInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var data = table.state.data;
    var modelFileName = table.state.currentModel + '.rb';
    var modelFile = data.modelFile;
    var paddedModelFile = padModelFile(modelFile);

    if (show) {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>{ modelFileName }</div>
          <section className='model'>
            { paddedModelFile }
          </section>
        </div>
      )
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>{ modelFileName }</div>
        </div>
      )
    };
    function padModelFile(modelFile) {
      var paddedModelFile = [];
      var lines = modelFile.split('\n');
      for (var i = 1; i <= lines.length - 2; i++) {
        if (i === 1 || i === lines.length - 2) {
          paddedModelFile.push(<span key={ 'file-line-' + i }>{ lines[i] }<br /></span>);
        } else {
          paddedModelFile.push(<span key={ 'file-line-' + i }><span className='pad'>..</span>{ lines[i] }<br /></span>);
        }
      }
      return paddedModelFile;
    }
  },
  clicked: function(show) {
    this.setState({ show: !show })
  }
});
