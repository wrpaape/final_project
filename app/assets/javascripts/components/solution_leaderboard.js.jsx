/* globals React */
'use strict';

var SolutionLeaderboard = React.createClass({
  render: function () {
    var show = this.props.show;
    var raw = this.props.raw;
    var formattedSol = raw;

    return (
      <td className={ 'sol-' + show }>
        { formattedSol }
      </td>
    );
  }
});
