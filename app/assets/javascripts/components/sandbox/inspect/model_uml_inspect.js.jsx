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
    var data = table.state.data;
    var umlFilePath = '/assets/environment' + data.environmentId + '_uml.png';

    if (show) {
      return(
        <div>
          <div data-id={ show } onClick={ this.clicked.bind(this, show) } className='wind0w-button btn btn-default show-hide'>UML</div>
          <Img src={ umlFilePath } className='image-uml'/>
        </div>
      );
    } else {
      return(
        <div data-id={ show } onClick={ this.clicked.bind(this, show) } className='wind0w-button btn btn-primary show-hide'>UML</div>
      );
    };
  },
  clicked: function(show) {
    this.setState({ show: !show });
  }
});
