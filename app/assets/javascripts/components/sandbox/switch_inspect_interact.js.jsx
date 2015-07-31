/* globals React */
'use strict';

var SwitchInspectInteract = React.createClass({
  getInitialState: function() {
    return {
      highlightInstructions: true,
      showInspect: true,
      showInteract: false,
      editorSwitched: false,
      selectedDoc: 'http://guides.rubyonrails.org/active_record_querying.html',
      hoveredText: [<span key='hovered-text-init'></span>]
    };
  },
  componentDidMount: function() {
    $('#page-cover').removeClass('cursor-progress');
  },
  render: function() {
    var showInspect = this.state.showInspect;
    var showInteract = this.state.showInteract;
    var editorSwitched = this.state.editorSwitched;
    var selectedDoc = this.state.selectedDoc;
    var hoveredText = this.state.hoveredText;
    var problem = this.props.problem;
    var instructions = problem.instructions.split('\n');
    var buttonContents = showInspect ? [<span key='solution'><span>enter your&nbsp;</span><span className='code code-general'>solution</span></span>] : [<span key='environment'><span>inspect your&nbsp;</span><span className='code code-ar-keyword'>environment</span></span>];
    var umlFilePath = '/assets/environment' + this.props.dataInspect.environmentId + '_uml.png';
    var formattedInstructions = [];
    instructions.forEach(function(line, i) {
      if (line.length === 0) {
        line = ' ';
      }
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

    var arDocs = {
      'query interface': 'http://guides.rubyonrails.org/active_record_querying.html',
      'associations': 'http://guides.rubyonrails.org/association_basics.html',
      'basics': 'http://guides.rubyonrails.org/active_record_basics.html',
      'migrations': 'http://guides.rubyonrails.org/active_record_migrations.html',
      'validations': 'http://guides.rubyonrails.org/active_record_validations.html',
      'callbacks': 'http://guides.rubyonrails.org/active_record_callbacks.html'
    }
    var docOptions = [];
    Object.keys(arDocs).forEach(function(doc) {
      docOptions.push(<option key={ doc + '-option' } value={ arDocs[doc] }>{ doc }</option>);
    }.bind(this));

    return(
      <div className='switch'>
        <div className='sticky-header'>
          <a href='/environments/' className='btn btn-primary'>
            <span>back to&nbsp;</span><span className='code code-ar-keyword'>environment</span><span>s</span>
          </a>
          <div className='select-wrap'>
            <a href={ selectedDoc } target='_blank' className='btn btn-primary ar-docs'>
              <span className='code code-ar-keyword'>ActiveRecord</span>
              <span className='docs'>doc</span>
            </a>
            <select className='btn btn-primary ar-docs' id='current-doc' onChange={ this.selectDoc }>
              { docOptions }
            </select>
          </div>
          <button type='button' className={ 'btn btn-primary instructions-highlight-' + this.state.highlightInstructions } data-toggle='modal' data-target='.instructions' onClick={ this.switchIntructionsHighlight }>
            { '\'' + problem.title + '\'' }
          </button>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target='.uml'>
            UML
          </button>
          <div id={ 'editor-switch-' + editorSwitched } className='btn btn-primary' onClick={ this.switched }>
            { buttonContents }
          </div>
        </div>
        <div className={ 'show-' + showInspect }>
          <TableInspect data={ this.props.dataInspect } models={ this.props.modelsInspect } />
        </div>
        <div className={ 'show-' + showInteract }>
          <TableInteract data={ this.props.dataInteract } url={ this.props.urlInteract } problem={ problem } loggedIn={ this.props.loggedIn } />
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
        <div className='modal fade disp-text' tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content text'>
              { hoveredText }
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
      showInteract: newShowInteract,
      editorSwitched: true
    });
  },
  switchIntructionsHighlight: function() {
    this.setState({ highlightInstructions: false });
  },
  selectDoc: function() {
    var newDoc = $('#current-doc').val();
    this.setState({ selectedDoc: newDoc })
  }
});
