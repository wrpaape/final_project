/* globals React */
'use strict';

var DisplayResultsInteract = React.createClass({
  render: function () {
    var table = this.props.parent;
    var results = table.state.results;
    var times = results.times;
    console.log('hi');

    Object.keys(times).forEach(function (key) {

      var time = times[key];
      if (time !== 'N/A') {
        if (key !== 'timeExecTotal') {
          times[key] = time >= 1000 ? Number(time / 1000).toPrecision(4) + ' s' : Number(time).toPrecision(4) + ' ms';
        } else {
          times[key] = time >= 1 ? Number(time).toPrecision(4) + ' s' : Number(time * 1000).toPrecision(4) + ' ms';
        }
        times[key] = times[key].toString().length === 6 ? times[key].toPrecision(3) : times[key];
        console.log(times[key].toString().length);
      }
    });

    return(
      <div className='row'>
        <div className='row'>
          <div className='col-md-6'>
            Total Number of DB Queries:
          </div>
          <span>
            { results['numQueries'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Shortest Query Time:
          </div>
          <span>
            { times['timeQueryMin'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Longest Query Time:
          </div>
          <span>
            { times['timeQueryMax'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Average Query Time:
          </div>
          <span>
            { times['timeQueryAvg'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Total Query Time:
          </div>
          <span>
            { times['timeQueryTotal'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Total Time to Execute:
          </div>
          <span>
            { times['timeExecTotal'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Non-Whitespace Character Count:
          </div>
          <span>
            { results['solCharCount'] }
          </span>
        </div>
        <div className='row'>
          <div className='col-md-6'>
            Answered Correctly:
          </div>
          <span>
            { results['isCorrect'].toString() }
          </span>
        </div>
      </div>
    );

  }
});
