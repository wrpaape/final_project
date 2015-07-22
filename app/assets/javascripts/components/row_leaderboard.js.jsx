/* globals React */
'use strict';

var RowLeaderboard = React.createClass({
  getInitialState: function () {
    return {
      showSol: false,
      showStats: false
    };
  },
  render: function () {
    var cols = [];
    var showSol = this.state.showSol;
    var showStats = this.state.showStats;
    var row = this.props.row;
    var probId = this.props.probId;
    var solvedProbHash = this.props.solvedProb;
    var solvedProb = solvedProbHash.solvedProb;
    var user = solvedProbHash.user;
    if (solvedProb.id === 20) {
       console.log(solvedProbHash);
      console.log(user);
      console.log(user.name);
    }

    var name = user.name === null ? 'nil' : user.name;
    var solCharCount = solvedProb.sol_char_count === null ? 'nil' : solvedProb.sol_char_count;
    var numQueries = solvedProb.num_queries === null ? 'nil' : solvedProb.num_queries;
    var createdAt = solvedProb.created_at === null ? 'nil' : solvedProb.created_at;
    var time = solvedProb.time_exec_total;

    var units = [' s', ' ms', ' μs'];
    var unit = '';
    if (time === null) {
      time = 'nil';
    } else if (time === 0) {
      unit += ' s';
    } else if (time !== 'N/A' && !isNaN(time)) {
      var n = 0;
      while (time < 1) {
        time *= 1000;
        n++;
      }
      unit += units[n];
      time = Number(time).toPrecision(4);
    }

    cols.push(<td key={ 'row-' + solvedProb.id + '-name'}>{ name }</td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-time-exec'}>{ time + unit }</td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-sol'} id={ 'solved-prob-' + solvedProb.id + '-sol' } onClick={ this.revealSolution } className='center'>
      <Img className={ 'spoiler-sol ' + !showSol } src='/assets/spoilers.png' />
      <div className={ 'sol-char-count btn btn-primary ' + showSol } >
        <p>method body</p>
        <p>char count:</p>
        <br />
        <p>{ solCharCount }</p>
      </div>
    </td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-stats'} id={ 'solved-prob-' + solvedProb.id + '-stats' } onClick={ this.revealStats } className='center'>
      <Img className={ 'spoiler-stats ' + !showStats } src='/assets/spoilers.png' />
      <div className={ 'num-queries btn btn-primary ' + showStats } >
        <p>total num</p>
        <p>queries:</p>
        <br />
        <p>{ numQueries }</p>
      </div>
    </td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-created-at-' + row + '-prob-' + probId } id={ 'row-' + solvedProb.id + '-created-at-' + row + '-prob-' + probId } onMouseOver={ this.mouseOver.bind(this, createdAt, solvedProb, row, probId) } onMouseOut={ this.mouseOut.bind(this, createdAt, solvedProb, row, probId) }>{ createdAt }</td>);

    return (
      <tr>
        <tr>
          { cols }
        </tr>
        <tr>
          <SolutionLeaderboard raw={ solvedProb } show={ showSol } />
        </tr>
        <tr>
          <StatsLeaderboard raw={ solvedProb } show={ showStats } />
        </tr>
      </tr>
    );
  },
  revealSolution: function() {
    var oldState = this.state.showSol;
    this.setState({
      showSol: !oldState,
      showStats: false
    });
  },
  revealStats: function() {
    var oldState = this.state.showStats;
    this.setState({
      showSol: false,
      showStats: !oldState
    });
  },
  mouseOver: function(val, obj, row, probId) {
    var valFormatted;
    if (val === 'nil') {
      valFormatted = 'Invalid Date';
    } else {
      valFormatted = (moment(val).format('MM/DD/YYYY hh:mm a'));
    }
      var idSelector = '#row-' + obj.id + '-created-at-' + row + '-prob-' + probId ;
      $(idSelector).html(valFormatted);
      $(idSelector).addClass('formatted-time');
  },
  mouseOut: function(val, obj, row, probId) {
    var idSelector = '#row-' + obj.id + '-created-at-' + row + '-prob-' + probId ;
    $(idSelector).html(val);
    $(idSelector).removeClass('formatted-time');
  },
});
