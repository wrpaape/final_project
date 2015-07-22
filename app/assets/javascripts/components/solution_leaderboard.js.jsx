/* globals React */
'use strict';

var SolutionLeaderboard = React.createClass({
  render: function () {
    var formattedSol;
    var show = this.props.show;
    var solvedProb = this.props.raw;
    var sol = solvedProb.solution;
    if (sol === null) {
      formattedSol = 'nil';
    } else {
      formattedSol = [];
      var splitLines = sol.split('\n');
      splitLines.forEach(function(line, i) {
        var padIndex = line.search(/[^ ]/);
        var pad = new Array(padIndex + 1).join(' ');
        if (line.length === 0) {
          line = ' ';
        }
        formattedSol.push(<span key={ 'sol-' + solvedProb.id + '-line-' + i }><span className='pad'>{ pad }</span><span className='code code-general'>{ line.slice(padIndex) }</span><br /></span>);
      });
    }

    return (
      <td colSpan='5' className={ 'sol ' + show }>
        <div className='sol-wrap'>
          { formattedSol }
        </div>
      </td>
    );
  }
});
