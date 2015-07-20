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
        <Img src='/assets/pig_glow.gif' className={ loadingClassName } />
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
      var lastLine = inputSolution.match(/[^\n].*[\n]*$/)[0].replace(/\n*$/,'');
      var methodName = lastLine.split(' ')[0];
      methodName = methodName === 'end' ? inputSolution.match(/def +([a-zA-Z_\?\d]*)/)[1] : methodName;
      var solCharCount = inputSolution.replace(/\n/g,'').replace(/ /g,'').replace(RegExp('def' + methodName),'').replace(RegExp('end' + methodName),'').length;
      var splitSolution = inputSolution.split('\n');
      for (var i = 0; i < splitSolution.length; i++)  {
        if (splitSolution[i].search(RegExp('def ' + methodName)) >= 0) {
          splitSolution.splice(i + 1, 0, '  status = Timeout::timeout(5) do');
          break;
        }
      };
      var reverseSplitSolution = splitSolution.reverse();
      for (var i = 0; i < reverseSplitSolution.length; i++) {
        if (reverseSplitSolution[i].search(RegExp('end')) >= 0) {
          reverseSplitSolution.splice(i + 1, 0, '  end');
          break;
        }
      };

      inputSolution = reverseSplitSolution.reverse().join('\n');
      var indentedSolution = inputSolution.replace(/\n/g, '\n  ');
      var putsSolution = indentedSolution.replace(RegExp('\n  ' + methodName, 'g'), '\n  start = Time.now\n  results = ' + methodName + '\n  finish = Time.now\n  results_hash = { "results"=> results, "time_exec"=> finish - start }\n  puts results_hash.to_json');
      var formattedSolution = 'require \'timeout\'\ntask :solution => :environment do\n  ActiveRecord::Base.logger = Logger.new(Rails.root.join("log", "solution_queries.log"))\n  ' + putsSolution + '\nend';


      var blackList = {
        '(`)': 'pls don\'t use backticks',
        '([\\s]system[ (])': 'pls don\`t call \'system\'',
        '([^Timeout]::[^Error: execution expired])': 'pls don\'t try to access methods you don\'t need',
        '(\\.send)': 'pls don\'t call \'send\'',
        '(\\.public_send)': 'pls don\'t call \'public_send\'',
        '(%x[-({])': 'pls don\'t use \'%x\'',
        '([\\s([{.]exec)': 'pls don\'t call \'exec\'',
        '([\\s([{.]require)': 'pls don\'t call \'require\'',
        '([\\s([{.]require_relative)': 'pls don\'t call \'require_relative\'',
        '([\\s([{.]load)': 'pls don\'t call \'load\'',
        '([\\s([{.]auto_load)': 'pls don\'t call \'auto_load\'',
        '(IO.)': 'pls don\'t try to access \'IO\'',
        '(File.)': 'pls don\'t try to access \'File\'',
        '(\\.create[^d_at])': 'pls don\'t try to change my db',
        '(\\.create_with)': 'pls don\'t try to change my db',
        '(\\.find_or_create_by)': 'pls don\'t try to change my db',
        '(\\.find_or_initialize_by)': 'pls don\'t try to change my db',
        '(\\.update[^d_at])': 'pls don\'t try to change my db',
        '(\\.update_all)': 'pls don\'t try to change my db',
        '(\\.destroy)': 'pls don\'t try to change my db',
        '(\\.destroy_all)': 'pls don\'t try to change my db',
        '(\\.delete)': 'pls don\'t try to change my db',
        '(\\.delete_all)': 'pls don\'t try to change my db',
        '(\\.save)': 'pls don\'t try to change my db',
        '((^|[\\s.(])User[\\s.())])': 'access denied',
        '((^|[\\s.(])Problem[\\s.())])': 'access denied',
        '((^|[\\s.(])SolvedProblem[\\s.())])': 'access denied',
        '((^|[\\s.(])Environment[\\s.())])': 'access denied'
      }

      var warnings = [];
      var keys = Object.keys(blackList);
      keys.forEach(function (key) {
        if (inputSolution.search(RegExp(key),'g') >= 0) {
          warnings.push(blackList[key]);
        }
      });

      var opacityLevel = warnings.length;

      if (opacityLevel > 0) {
        var nuh = 'nuh';
        var uh = 'uh';

        var newmanLevel = 1;
        if (opacityLevel > 2) {
          newmanLevel = 2;
          nuh = 'NUH';
          uh = 'UH';
          var warnings = warnings.map(function (warning) {
            warning = warning.toUpperCase();
            return warning;
          })
        }
        if (opacityLevel > 4) {
          newmanLevel = 3;
          nuh = 'STOP IT';
          uh = 'STOP IT';
          opacityLevel = 5;
           var warnings = warnings.map(function (warning) {
            warning += ' ' + warning + ' ' + warning + ' ' + warning + ' ' + warning;
            return warning;
          })
        }

        table.setState({
          newman: true,
          newmanLevel: newmanLevel,
          opacityLevel: opacityLevel,
          data: warnings,
          results: {
            'isCorrect': false,
            'numQueries': 0,
            'solCharCount': solCharCount,
            'times': {
              'timeExecTotal': 'N/A',
              'timeQueryTotal': 'N/A',
              'timeQueryMin': nuh,
              'timeQueryMax': uh,
              'timeQueryAvg': uh
            }
          },
          loading: false
        });
        this.setState({ loading: false });
      } else {
        $.getJSON(table.props.url,
          {
            interact: true,
            solution: formattedSolution,
            problem_id: table.props.problem.id
          },
          function(newData) {
            var data = newData.results;
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
              newman: false,
              newmanLevel: 1,
              opacityLevel: 0,
              loading: false
            });
            this.setState({ loading: false });
          }.bind(this)
        )
      }
    }
  }
});
