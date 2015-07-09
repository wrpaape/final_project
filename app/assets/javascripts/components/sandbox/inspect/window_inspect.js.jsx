/* globals React */
'use strict';

var WindowInspect = React.createClass({
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
          <ModelFileInspect key='model-file' grandparent={ table } />
        </div>
        <div className='row'>
          <ModelSchemaInspect key='model-schema' grandparent={ table } />
        </div>
        <div className='row'>
          <SelectedObjInspect key='selected-obj' grandparent={ table } />
        </div>
        <div className='row'>
          <SearchBarInspect key='search-bar' grandparent={ table } />
        </div>
      </div>
    );
  }
});
