/* globals React */
'use strict';

var DisplayResultsInteract = React.createClass({
  getInitialState: function () {
    return {
      showCorrect: this.props.showCorrect
    };
  },
  componentWillReceiveProps: function (nextProps) {
    this.setState({
      showCorrect: nextProps.showCorrect
    });
  },
  render: function () {
    var table = this.props.parent;
    var results = table.state.results;
    var times = results.times;
    var units = [' s', ' ms', ' μs'];

    Object.keys(times).forEach(function (key) {
      if (times[key] !== 'N/A' && !isNaN(times[key])) {
        var n = 0;
        while (times[key] < 1) {
          times[key] *= 1000;
          n++;
        }
        times[key] = Number(times[key]).toPrecision(4) + units[n];
      }
    });

    var user = table.state.user;
    var isCorrect = table.state.results.isCorrect;
    var showCorrect = this.state.showCorrect;
    var dispCorrect = showCorrect ? results.isCorrect.toString() : '?????';
    var buttonContents = (showCorrect && isCorrect) ? (user === null ? 'sign in/up to\nsubmit |solution' : 'submit |solution') : 'check answer';
    var splitContents = buttonContents.split('\n');
    var formatteddContents = [];


    splitContents.forEach(function(line, i){
      if (i === (splitContents.length - 1)) {
        var formattedSegs = [];
        var segs = line.split('|');
        segs.forEach(function(seg, j){
          formattedSegs.push(<span key={ 'seg-' + j } className={ j === 1 ? 'code code-general' : '' }>{ seg }</span>);
        });
        formatteddContents.push(<span key={ 'plain-' + i }>{ formattedSegs }</span>)
      } else {
        formatteddContents.push(<p key={ 'sign-in-up-' + i }>sign <button className='sign-in' data-toggle="modal" data-target=".sign-in-form">in</button> or <button className='sign-up' data-toggle="modal" data-target=".sign-up-form">up</button>&nbsp;to</p>)
      }
    });

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
          <div className={ 'correct value show-correct-' + showCorrect + ' is-correct-' + isCorrect }>
            { dispCorrect }
          </div>
          <div className='btn btn-primary' onClick={ this.clicked.bind(this, user, showCorrect, isCorrect) }>
            { formatteddContents }
          </div>
        </div>
      </div>
    );
  },
  clicked: function (user, showCorrect, isCorrect) {
    if (showCorrect && isCorrect) {
      if (user === null) {

      } else {

      }
    } else {
      this.setState({ showCorrect: true });
    }
  }
});
