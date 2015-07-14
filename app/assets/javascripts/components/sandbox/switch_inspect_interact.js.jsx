/* globals React */
'use strict';

var SwitchInspectInteract = React.createClass({
  getInitialState: function() {
    return {
      showInspect: true,
      showInteract: false,
      numSwitches: 0
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
    var newNumSwitches = this.state.numSwitches + 1;
    if (newNumSwitches === 1) {
      // $('#editor').ace({ theme: 'monokai', lang: 'ruby' });
      // var editor = document.querySelector('.ace_editor').env.editor;
      // editor.getSession().setTabSize(2);
      // editor.gotoLine(2);
      // editor.insert('  ');
      // updateHiddenInput();
      // editor.getSession().on('change', function() {
      //   updateHiddenInput();
      // });
      // function updateHiddenInput() {
      //   var hiddenInput = $('input[name="editor-content"]');
      //   hiddenInput.val(editor.getSession().getValue());
      // }
    }
    this.setState({
      showInspect: newShowInspect,
      showInteract: newShowInteract,
      numSwitches: newNumSwitches
    });
  }
});
