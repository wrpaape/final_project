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
    var availableModels = table.props.availableModels;
    var modelOptions = [];

    availableModels.forEach(function (model) {
      modelOptions.push(<option value={ model }>{ model }</option>);
    });

    return(
      <div>
        <div className='row'>
          <select id='current-model' onChange={ this.selected.bind(this, table) } >
            { modelOptions }
          </select>
        </div>
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
  },
  selected: function (table) {
    var currentModel = table.state.currentModel;
    var newModel = $('#current-model').val();
    if (currentModel !== newModel) {
      table.setState({ loading: true });
      $.getJSON(table.state.data.url,
        {
          model: newModel
        },
      function (newData) {
        table.setState({
          data: newData,
          currentModel: newModel,
          limit: 10,
          offset: 0,
          search: '',
          sort: '',
          caseSens: 'false',
          fuzzy: 'true',
          windowObj: { id: 0 },
          loading: false
        })
      }
    }
  }
});
