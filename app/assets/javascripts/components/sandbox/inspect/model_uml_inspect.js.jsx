/* globals React */
'use strict';

var ModelUmlInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var currentModel = table.state.currentModel;
    var umlFilePath = 'assets/' + currentModel + '_uml.png';

    if (show) {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>UML</div>
          <img src={ umlFilePath } className='image-uml'/>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>UML</div>
        </div>
      );
    };
  },
  clicked: function(show) {
    this.setState({ show: !show })
  }
});
