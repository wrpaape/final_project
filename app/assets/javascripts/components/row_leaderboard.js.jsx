/* globals React */
'use strict';

var RowLeaderboard = React.createClass({
  render: function () {
    var cols = [];
    var solvedProb = this.props.solvedProb;
    var keys = Object.keys(solvedProb);

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker td' : 'lighter td';
      var val = solvedProb[keys[i]];

      if (val === null) {
        val = 'nil';
      }

      cols.push(<td id={ 'leaderboard-row-' + solvedProb.id + '-col-' + i } key={ 'row-' + solvedProb.id + '-col-' + i } className={ className } onMouseOver={ this.mouseOver.bind(this, val, solvedProb, i) } onMouseOut={ this.mouseOut.bind(this, val, solvedProb, i) }>{ val }</td>);
    }
    return (
      <tr id={ solvedProb.id } className={ className }>
        { cols }
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
  }
});
