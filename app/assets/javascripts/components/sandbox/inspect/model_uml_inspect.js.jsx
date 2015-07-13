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
    var window = this.props.parent;
    var table = this.props.grandparent;
    var currentModel = table.state.currentModel;
    var umlFilePath = '/assets/' + currentModel + '_uml.png';

    if (show) {
      return(
        <div>
          <div onClick={ this.clicked.bind(this, show, window) } className='btn btn-default show-hide'>UML</div>
          <img src={ umlFilePath } className='image-uml'/>
        </div>
      );
    } else {
      return(
        <div>
          <div onClick={ this.clicked.bind(this, show, window) } className='btn btn-primary show-hide'>UML</div>
        </div>
      );
    };
  },
  clicked: function(show, window) {
    var newShow = !show;
    this.setState({ show: newShow })
    if (newShow) {
      window.setState({ enableToggle: false });
    } else {
      window.setState({ enableToggle: true });
    }
  }
});
