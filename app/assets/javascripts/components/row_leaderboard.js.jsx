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
    var solvedProbHash = this.props.solvedProb;
    var solvedProb = solvedProbHash.solvedProb;
    var user = solvedProbHash.user;
    var time = solvedProb.time_exec_total;
    var createdAt = solvedProb.created_at;

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

    cols.push(<td key={ 'row-' + solvedProb.id + '-name'}>{ user.name }</td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-time-exec'}>{ time + unit }</td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-sol'} id={ 'solved-prob-' + solvedProb.id + '-sol' } onClick={ this.revealSolution } className='center'>
      <Img className={ 'spoiler-sol ' + !showSol } src='/assets/spoilers.png' />
      <div className={ 'sol-char-count btn btn-primary ' + showSol } >
        <p>method body</p>
        <p>char count:</p>
        <br />
        <p>{ solvedProb.sol_char_count }</p>
      </div>
    </td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-stats'} id={ 'solved-prob-' + solvedProb.id + '-stats' } onClick={ this.revealStats } className='center'>
      <Img className={ 'spoiler-stats ' + !showStats } src='/assets/spoilers.png' />
      <div className={ 'num-queries btn btn-primary ' + showStats } >
        <p>total num</p>
        <p>queries:</p>
        <br />
        <p>{ solvedProb.num_queries }</p>
      </div>
    </td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-created-at'} id={ 'row-' + solvedProb.id + '-created-at'} onMouseOver={ this.mouseOver.bind(this, createdAt, solvedProb) } onMouseOut={ this.mouseOut.bind(this, createdAt, solvedProb) }>{ createdAt }</td>);

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
    this.setState({
      showSol: true,
      showStats: false
    });
  },
  revealStats: function() {
    this.setState({
      showSol: false,
      showStats: true
    });
  },
  mouseOver: function(val, obj) {
    var valFormatted = (moment(val).format('MM/DD/YYYY hh:mm a'));
    var idSelector = '#row-' + obj.id + '-created-at';
    $(idSelector).html(valFormatted);
    $(idSelector).addClass('formatted-time');
  },
  mouseOut: function(val, obj) {
    var idSelector = '#row-' + obj.id + '-created-at';
    $(idSelector).html(val);
    $(idSelector).removeClass('formatted-time');
  },
});
