/* globals React */
'use strict';

var WindowInspect = React.createClass({
  getInitialState: function () {
    return {
      highlight: true,
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var enableToggle = this.state.enableToggle;
    var table = this.props.parent;
    var data = table.state.data;
    var availableModels = Object.keys(table.state.models);
    var currentModel = table.state.currentModel;
    var modelOptions = [];
    var modelFileName = table.state.models[currentModel].fileName;
    var migrationFileName = data.migrationFileName.split('\n');

    availableModels.forEach(function (model) {
      modelOptions.push(<option key={ model + 'option' } className='model-option' value={ model }>{ model }</option>);
    });

    var noneSelected = function() {
      var selected = true;
      var allButtons = $('.wind0w-button');
      allButtons.each(function (i) {
        if ($(this).attr('data-id') === 'true') {
          selected = false;
        }
      });
      return selected;
    }

    if (show) {
    return(
      <div className='inspector-hide' onMouseLeave={ this.mouseLeave.bind(this, show, table, noneSelected) }>
        <select className='btn btn-primary show-hide' id='current-model' onChange={ this.selected.bind(this, table) } >
          { modelOptions }
        </select>
        <button type='button' className='btn btn-primary show-hide' data-toggle='modal' data-target='.model-file'>
          { modelFileName }
        </button>
        <button type='button' className='btn btn-primary show-hide smaller' data-toggle='modal' data-target='.migration-file'>
          <span>{ migrationFileName[0] }</span>
          <br />
          <span>{ migrationFileName[1] }</span>
        </button>
        <SelectedObjInspect key='selected-obj' grandparent={ table } parent={ this } />
        <SearchBarInspect key='search-bar' grandparent={ table } parent={ this } />
      </div>
    );
    } else {
      var vertText = 'show  inspector'.split('');
      vertText = vertText.join('\n');

      return(
        <div className={ 'inspector-show ' + this.state.highlight } onMouseEnter={ this.mouseEnter.bind(this, show, table) }>
          { vertText }
        </div>
      )
    }
  },
  mouseEnter: function(show, table) {
    this.setState({
      highlight: false,
      show: !show
    });
    table.setState({ padding: 165 });
  },
  mouseLeave: function(show, table, noneSelected) {
    if (noneSelected()){
      this.setState({ show: !show });
      table.setState({ padding: 25 });
    }
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
          inspect: true,
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
