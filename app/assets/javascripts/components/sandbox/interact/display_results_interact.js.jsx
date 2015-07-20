/* globals React */
'use strict';

var DisplayResultsInteract = React.createClass({
  getInitialState: function () {
    return {
      showCorrect: false
    };
  },
  render: function () {
    var table = this.props.parent;
    var results = table.state.results;
    var times = results.times;
    var units = [' s', ' ms', ' μs'];

    Object.keys(times).forEach(function (key) {
      if (times[key] !== 'N/A' && !isNaN(times[key])) {
        if (key !== 'timeExecTotal') {
          times[key] /= 1000;
        }
        var n = 0;
        while (times[key] < 1) {
          times[key] *= 1000;
          n++;
        }
        times[key] = Number(times[key]).toPrecision(4) + units[n];
      }
    });

    var isCorrect = table.state.results.isCorrect;
    var showCorrect = this.state.showCorrect;
    var dispCorrect = showCorrect ? results.isCorrect.toString() : '????';
    var buttonContents = (showCorrect && isCorrect) ? 'submit solution' : 'check answer';

    return(
      <div className='display-results'>
        <div>
          <div className='type'>
            &nbsp;&nbsp;&nbsp;&nbsp;total queries:
          </div>
          <div className='value'>
            { results['numQueries'] }
          </div>
        </div>
        <div>
          <div className='type'>
            &nbsp;&nbsp;&nbsp;shortest query:
          </div>
          <div className='value'>
            { times['timeQueryMin'] }
          </div>
        </div>
        <div>
          <div className='type'>
            &nbsp;&nbsp;&nbsp;&nbsp;longest query:
          </div>
          <div className='value'>
            { times['timeQueryMax'] }
          </div>
        </div>
        <div>
          <div className='type'>
            &nbsp;&nbsp;&nbsp;&nbsp;average query:
          </div>
          <div className='value'>
            { times['timeQueryAvg'] }
          </div>
        </div>
        <div>
          <div className='type'>
            &nbsp;total query time:
          </div>
          <div className='value'>
            { times['timeQueryTotal'] }
          </div>
        </div>
        <div>
          <div className='type'>
            &nbsp;&nbsp;time to execute:
          </div>
          <div className='value'>
            { times['timeExecTotal'] }
          </div>
        </div>
        <div>
          <div className='type'>
            non-ws char count:
          </div>
          <div className='value'>
            { results['solCharCount'] }
          </div>
        </div>
        <div>
          <div className='type'>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;correct:
          </div>
          <div className='value'>
            { dispCorrect }
          </div>
          <div className='btn btn-primary' onClick={ this.clicked }>
            { buttonContents }
          </div>
        </div>
      </div>
    );
  },
  clicked: function () {
    this.setState({ showCorrect: true });
  }
});
