/* globals React */
'use strict';

var DisplayResultsInteract = React.createClass({
  getInitialState: function () {
    return {
      showCorrect: this.props.showCorrect,
      loggedIn: this.props.loggedIn
    };
  },
  componentWillReceiveProps: function (nextProps) {
    var newTable = nextProps.parent;
    var oldLoggedIn = this.state.loggedIn;
    var newLoggedIn = newTable.state.loggedIn;
    var showCorrect = false;
    if (newLoggedIn && !oldLoggedIn) {
      showCorrect = true;
    }
    this.setState({
      showCorrect: showCorrect,
      loggedIn: newLoggedIn
    });
  },
  render: function () {
    var displayResults = this;
    var table = this.props.parent;
    var results = table.state.results;
    var times = $.extend({}, results.times);
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

    var loggedIn = table.state.loggedIn;
    var isCorrect = table.state.results.isCorrect;
    var showCorrect = this.state.showCorrect;
    var dispCorrect = showCorrect ? results.isCorrect.toString() : '?????';
    var buttonContents = (showCorrect && isCorrect) ? (loggedIn ? 'submit |solution' : 'sign in/up to\nsubmit |solution') : 'check answer';
    var splitContents = buttonContents.split('\n');
    var formatteddContents = [];
    var buttonClass = 'btn btn-primary';
    buttonClass += (showCorrect && isCorrect && loggedIn) ? ' shine' : '';


    splitContents.forEach(function(line, i){
      if (i === (splitContents.length - 1)) {
        var formattedSegs = [];
        var segs = line.split('|');
        segs.forEach(function(seg, j){
          formattedSegs.push(<span key={ 'seg-' + j } className={ j === 1 ? 'code code-general' : '' }>{ seg }</span>);
        });
        formatteddContents.push(<span key={ 'plain-' + i }>{ formattedSegs }</span>)
      } else {
        formatteddContents.push(<p key={ 'sign-in-up-' + i }>sign <button onClick={ displayResults.listenForAjax } id='sign-up' className='sign-up' data-toggle="modal" data-target=".sign-up-form">up</button> or <button onClick={ displayResults.listenForAjax } id='sign-in' className='sign-in' data-toggle="modal" data-target=".sign-in-form">in</button>&nbsp;to</p>)
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
          <div id='check-answer' className={ buttonClass } onClick={ this.clicked.bind(this, loggedIn, showCorrect, isCorrect) }>
            { formatteddContents }
          </div>
        </div>
      </div>
    );
  },
  clicked: function (loggedIn, showCorrect, isCorrect) {
    if (showCorrect && isCorrect) {
      if (loggedIn) {
        var table = this.props.parent;
        var results = table.state.results;
        var times = results.times;
        var params = {
          'solution': table.state.solution,
          'sol_char_count': results.solCharCount,
          'time_exec_total': times.timeExecTotal,
          'time_query_total': times.timeQueryTotal,
          'time_query_min': times.timeQueryMin,
          'time_query_max': times.timeQueryMax,
          'time_query_avg': times.timeQueryAvg,
          'num_queries': results.numQueries
        };
        var keys = Object.keys(params);
        var serialized = keys.map(function(key, i) {
          return key + '=' + encodeURIComponent(params[key]);
        });
        var urlParams = '?' + serialized.join('&');
        window.location.href = table.state.newSolvedProblem + urlParams;
      }
    } else {
      $('#check-answer').removeClass('shine');
      this.setState({ showCorrect: true });
    }
  },
  listenForAjax: function () {
    var table = this.props.parent;
    $(document).ajaxSuccess(function(){
      $('#modal-sign-up').modal('hide');
      $('#modal-sign-in').modal('hide');
      table.setState({ loggedIn : true });
      $(document).unbind("ajaxSuccess");
    });
  }
});
