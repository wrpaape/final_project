/* globals React */
'use strict';

var WindowInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var table = this.props.parent;
    var availableModels = Object.keys(table.state.models);
    var modelOptions = [];

    availableModels.forEach(function (model) {
      modelOptions.push(<option key={ model + 'option' } value={ model }>{ model }</option>);
    });

    if (this.state.show) {
    return(
      <div className='inspector-hide' >
        <div className='relative' >
          <div className='row select-wrap'>
            <select className='btn btn-default show-hide' id='current-model' onChange={ this.selected.bind(this, table) } >
              { modelOptions }
            </select>
          </div>
          <div className='row'>
            <ModelUmlInspect key='model-uml' grandparent={ table } />
          </div>
          <div className='row'>
            <ModelFileInspect key='model-file' grandparent={ table } />
          </div>
          <div className='row'>
            <ModelMigrationInspect key='model-migration' grandparent={ table } />
          </div>
          <div className='row'>
            <SelectedObjInspect key='selected-obj' grandparent={ table } />
          </div>
          <div className='row'>
            <SearchBarInspect key='search-bar' grandparent={ table } />
          </div>
        </div>
      </div>
    );
    } else {
      var vertText = 'Show Inspector'.split('');
      vertText = vertText.join('\n');
      return(
        <div className='inspector-show' onMouseOver={ this.mouseOver }>
          { vertText }
        </div>
      )
    }
  },
  mouseOver: function() {
    this.setState({ show: true });
  },
  mouseOut: function() {
    this.setState({ show: false });
  },
  selected: function (table) {
    var currentModel = table.state.currentModel;
    var newModel = $('#current-model').val();
    if (currentModel !== newModel) {
      var models = table.state.models;
      var newLimit = models[newModel].limit;
      var newOffset = models[newModel].offset;
      var newSearch = models[newModel].search;
      var newSort = models[newModel].sort;
      var newCaseSens = models[newModel].caseSens;
      var newFuzzy = models[newModel].fuzzy;

      table.setState({ loading: true });
      $.getJSON(table.state.data.url,
        {
          limit: newLimit,
          offset: newOffset,
          search: newSearch,
          sort: newSort,
          caseSens: newCaseSens,
          fuzzy: newFuzzy,
          current_model: newModel
        },
        function (newData) {
          table.setState({
            data: newData,
            currentModel: newModel,
            limit: newLimit,
            offset: newOffset,
            search: newSearch,
            sort: newSort,
            caseSens: newCaseSens,
            fuzzy: newFuzzy,
            loading: false
          })
        }
      )
    }
  }
});
