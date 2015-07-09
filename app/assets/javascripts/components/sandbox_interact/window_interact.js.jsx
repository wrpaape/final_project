/* globals React */
'use strict';

var WindowInteract = React.createClass({
  getInitialState: function () {
    return {
      show: 'false'
    };
  },
  render: function() {
    var table = this.props.parent;

    return(
      <div>
        <div className='row'>
          <ModelFile key='model-file' grandparent={ table } />
        </div>
        <div className='row'>
          <ModelSchema key='model-schema' grandparent={ table } />
        </div>
        <div className='row'>
          <SelectedObj key='selected-obj' grandparent={ table } />
        </div>
      </div>
    );
  }
});
