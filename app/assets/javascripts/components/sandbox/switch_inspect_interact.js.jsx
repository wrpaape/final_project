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
    var problem = this.props.problem;
    var instructions = problem.instructions.split('\n');
    var buttonContents = showInspect ? 'Enter your Solution' : 'Inspect your Environment';
    var umlFilePath = '/assets/environment' + this.props.dataInspect.environmentId + '_uml.png';
    var formattedInstructions = [];
    instructions.forEach(function(line, i) {
      var splitLine = line.split('|');
      var formattedLine = [];
      splitLine.forEach(function(seg, i) {
        var className = '';
        if (i % 2 !== 0) {
          className += 'code';
          if (seg[0] !== undefined && seg[0] === seg[0].toUpperCase()) {
            className += '-model';
          }
        }
        formattedLine.push(<span key={ 'seg' + i } className={ className }>{ seg }</span>);
      });
      formattedInstructions.push(<p key={ 'line' + i }>{ formattedLine }</p>);
    });

    return(
      <div className='switch'>
        <div className='sticky-header'>
          <div className='btn btn-primary' onClick={ this.switched }>
            { buttonContents }
          </div>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target='.instructions'>
            { '\'' + problem.title + '\' instructions' }
          </button>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target='.uml'>
            UML
          </button>
        </div>
        <div className={ 'show-' + showInspect }>
          <TableInspect data={ this.props.dataInspect } models={ this.props.modelsInspect } />
        </div>
        <div className={ 'show-' + showInteract }>
          <TableInteract data={ this.props.dataInteract } url={ this.props.urlInteract } problem={ problem } />
        </div>
        <div className='modal fade instructions' tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content'>
              { formattedInstructions }
            </div>
          </div>
        </div>
        <div className='modal fade uml' tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content image'>
              <img src={ umlFilePath } className='image-uml'/>
            </div>
          </div>
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
