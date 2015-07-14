/* globals React */
'use strict';

var EditorInteract = React.createClass({
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
        <img src='/assets/pig_glow.gif' className={ loadingClassName } />
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
      var putsSolution = indentedSolution.replace(/\n  solution/g, '\n  start = Time.now\n  results = solution\n  finish = Time.now\n  results_hash = { "results"=> results.to_json, "time_exec"=> finish - start }\n  puts results_hash.to_json');
      var formattedSolution = 'task :solution => :environment do\n  Rails.logger = Logger.new("log/solution_queries.log")\n  ' + putsSolution + '\nend';
      var solCharCount = inputSolution.replace(/\n/g,'').replace(/ /g,'').replace(/defsolution/,'').replace(/endsolution/,'').length;


      $.getJSON(table.props.url,
        {
          interact: true,
          solution: formattedSolution,
          problem_id: table.props.problemId
        },
        function(newData) {
          var data = newData.results;
          if (typeof(data[0]) === 'string') {
            var showHead = false;
          } else {
            var dataTypes = [];
            data.forEach(function (obj) {
              dataTypes.push(typeof(obj));
            });
            var showHead = dataTypes.reduce(function(a, b){return (a === b) ? a : false;});
            showHead = showHead === false ? showHead : true;
          }

          table.setState({
            data: data,
            results: {
              'isCorrect': newData.isCorrect,
              'numQueries': newData.numQueries,
              'solCharCount': solCharCount,
              'times': {
                'timeExecTotal': newData.timeExecTotal,
                'timeQueryTotal': newData.timeQueryTotal,
                'timeQueryMin': newData.timeQueryMin,
                'timeQueryMax': newData.timeQueryMax,
                'timeQueryAvg': newData.timeQueryAvg,
              }
            },
            showHead: showHead,
            loading: false
          });
          this.setState({ loading: false });
        }.bind(this)
      );
    }
  }
});
