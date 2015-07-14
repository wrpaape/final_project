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
    var currentModel = table.state.currentModel;
    var modelFileName = table.state.models[currentModel].fileName;
    var data = table.state.data;
    var modelFile = data.modelFile;
    var paddedModelFile = padModelFile(modelFile);

    if (show) {
      return(
        <div>
          <div data-id={ show } onClick={ this.clicked.bind(this, show) } className='wind0w-button btn btn-default show-hide'>
            { modelFileName }
          </div>
          <section className='model'>
            { paddedModelFile }
          </section>
        </div>
      )
    } else {
      return(
        <div data-id={ show } onClick={ this.clicked.bind(this, show) } className='wind0w-button btn btn-primary show-hide'>
          { modelFileName }
        </div>
      )
    };
    function padModelFile(modelFile) {
      var paddedModelFile = [];
      var lines = modelFile.split('\n');
      for (var i = 1; i <= lines.length - 1; i++) {
        var padIndex = lines[i].search(/[a-z]/);
        var pad = new Array(padIndex + 1).join('~');
        var line = lines[i].slice(padIndex);
        paddedModelFile.push(<span key={ 'model-line-' + i }><span className='pad'>{ pad }</span><span className='model-line'>{ line }</span><br /></span>);
      }
      return paddedModelFile;
    }
  },
  clicked: function(show) {
    this.setState({ show: !show })
  }
});
