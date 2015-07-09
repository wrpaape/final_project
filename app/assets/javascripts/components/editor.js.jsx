/* globals React */
'use strict';

var Editor = React.createClass({
  getInitialState: function () {
    return {
      loading: false
    };
  },
  render: function() {
    var initialText = 'def solution\n\nend\n\nsolution';
    var pressedKeys = [-1, -1, -1];
    var loadingClassName = 'loading-' + this.state.loading +' db-editor';
    var editorClassName = 'lighten-' + this.state.loading;
    return(
      <form id='editor-form' onKeyDown={ this.submitted.bind(this, pressedKeys) }>
        <img src='assets/pig_glow.gif' className={ loadingClassName } />
        <input type='hidden' id='editor-content' name='editor-content' />
        <div className={ editorClassName }>
          <textarea id='editor' defaultValue={ initialText } />
        </div>
      </form>
    );
  },
  submitted: function (pressedKeys, key) {
    var keyCode = key.keyCode;
    pressedKeys.push(keyCode);
    var lastIndex = pressedKeys.length - 1;
    var thirdLastIndex = lastIndex - 2;
    var ShiftReturn = $.inArray(13, pressedKeys, thirdLastIndex) > -1 && $.inArray(16, pressedKeys, thirdLastIndex) > -1;
    var leftCmdShiftReturn = (ShiftReturn && $.inArray(91, pressedKeys, thirdLastIndex) > -1);
    var rightCmdShiftReturn = (ShiftReturn && $.inArray(93, pressedKeys, thirdLastIndex) > -1);
    var ctrShiftReturn = (ShiftReturn && $.inArray(17, pressedKeys, thirdLastIndex) > -1);

    if (leftCmdShiftReturn || rightCmdShiftReturn || ctrShiftReturn) {
      var table = this.props.parent;
      this.setState({ loading: true });
      table.setState({ loading: true });
      var inputSolution = $('#editor-content').val();
      var indentedSolution = inputSolution.replace(/\n/g, '\n  ');
      var putsSolution = indentedSolution.replace(/\n  solution/g, '\n  puts solution.to_json');
      var formattedSolution = 'task :solution => :environment do\n  ' + putsSolution + '\nend';

      $.getJSON('solution',
        {
          solution: formattedSolution
        },
        function(newData) {
          table.setState({
            data: newData,
            loading: false
          });
          this.setState({ loading: false });
        }.bind(this)
      );
    }
  }
});
