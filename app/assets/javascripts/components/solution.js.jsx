/* globals React */
'use strict';

var Solution = React.createClass({
  render: function () {
    var show = this.props.show;
    var raw = this.props.raw;


    return (
      <tr className={ 'sol ' + show }>
        { FormattedSol }
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

  },
  revealStats: function() {

  }
});
