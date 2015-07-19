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
      splitLine.forEach(function(seg, j) {
        var className = '';
        if (j % 2 !== 0) {
          className += 'code ';
          if (seg[0] === '%') {
            className += 'code-general';
          } else if (seg[0] === '?') {
            className += ' code-sql';
          } else if (seg[0] === '#') {
            className += ' code-ar-keyword';
          } else if (seg[0] === '@') {
            className += ' code-table';
          } else if (seg[0] === '&') {
            className += ' code-relation';
          } else if (seg[0] === '*') {
            className += ' code-attribute';
          } else if (seg[0] === '~') {
            className += ' code-model';
          } else if (seg[0] === '`') {
              className += ' code-value';
          }
          seg = seg.slice(1);
        }
        formattedLine.push(<span key={ 'seg' + j } className={ className }>{ seg }</span>);
      });
      formattedInstructions.push(<p key={ 'line' + i }>{ formattedLine }</p>);
    });

    return(
      <div className='switch'>
        <div className='sticky-header'>
          <a href='/environments/' className='btn btn-primary'>
            <span>back to&nbsp;</span><span className='code code-ar-keyword'>environment</span><span>s</span>
          </a>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target='.instructions'>
            { '\'' + problem.title + '\' instructions' }
          </button>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target='.uml'>
            UML
          </button>
          <div className='btn btn-primary' onClick={ this.switched }>
            { buttonContents }
          </div>
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
              <Img src={ umlFilePath } className='image-uml'/>
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
