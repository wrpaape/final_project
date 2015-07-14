/* globals React */
'use strict';

var SwitchInspectInteract = React.createClass({
  getInitialState: function() {
    return {
      showInspect: true,
      showInteract: false
    };
  },
  render: function() {
    var showInspect = this.state.showInspect;
    var showInteract = this.state.showInteract;
    var btnContents = showInspect ? 'Enter your Solution' : 'Inspect your Environment';
    return(
      <div className='switch'>
        <div className='btn btn-primary' onClick={ this.switched }>
          { btnContents }
        </div>
        <div className={ 'show-' + showInspect }>
          <TableInspect data={ this.props.dataInspect } models={ this.props.modelsInspect } />
        </div>
        <div className={ 'show-' + showInteract }>
          <TableInteract data={ this.props.dataInteract } url={ this.props.urlInteract } problemId={ this.props.problemId } />
        </div>
      </div>
    );
  },
  switched: function() {
    var newShowInspect = !this.state.showInspect;
    var newShowInteract = !this.state.showInteract;
    this.setState({
      showInspect: newShowInspect,
      showInteract: newShowInteract
    });
  }
});
