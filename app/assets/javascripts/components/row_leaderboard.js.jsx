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

    cols.push(<td key={ 'row-' + solvedProb.id + '-time-exec'}>{ solvedProb.time_exec }</td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-name'}>{ user.name }</td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-sol'} id={ 'solved-prob-' + solvedProb.id + '-sol' } onClick={ this.revealSolution }><Img src='/assets/spoilers.png' /></td>);
    cols.push(<td key={ 'row-' + solvedProb.id + '-stats'} id={ 'solved-prob-' + solvedProb.id + '-stats' } onClick={ this.revealStats }><Img src='/assets/spoilers.png' /></td>);




    return (
      <tr>
        <table>
          <tr id={ solvedProb.id } className={ className }>
            { cols }
          </tr>
          <Solution raw={ solvedProb.solution } show={ showSol } />
          <Stats raw={ solvedProb } show={ showStats } />
        </table>
      </tr>
    );
  },
  mouseOver: function(val, solvedProb, i) {
    var isDatetime = val.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var valFormatted = (moment(val).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#leaderboard-row-' + solvedProb.id + '-col-' + i;
      $(idSelector).html(valFormatted);
      $(idSelector).addClass("formatted-time");
    }
  },
  mouseOut: function(val, solvedProb, i) {
    var idSelector = '#leaderboard-row-' + solvedProb.id + '-col-' + i;
    $(idSelector).html(val);
    $(idSelector).removeClass("formatted-time");
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
  }
});
