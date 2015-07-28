/* globals React */
'use strict';

var SolutionLeaderboard = React.createClass({
  render: function () {
    var show = this.props.show;
    var highlightBody = this.props.highlightBody;
    var solvedProb = this.props.raw;
    var sol = solvedProb.solution;
    var formattedSol = [];
    if (sol === null) {
      formattedSol.push(<span key={ 'sol-' + solvedProb.id + '-line-nil' } className='code code-general'>nil</span>);
    } else {
      var lastLine = sol.match(/[^\n].*[\n]*$/)[0].replace(/\n*$/,'');
      var methodName = lastLine.split(' ')[0];
      methodName = (methodName === 'end' || methodName[0] === '#') ? sol.match(/ *def +([a-zA-Z_\?\d]*)/g)[1] : methodName;
      var splitLines = sol.split('\n');
      var lineStartMethodBody;
      var lineEndMethodBody;
      var linesComment = [];
      splitLines.forEach(function(line, i) {
        if (line.search(RegExp(' *def +' + methodName)) !== -1) {
          lineStartMethodBody = i + 1;
        } else if (line.replace('end', '') === '') {
          lineEndMethodBody = i - 2;
        } else if (line.replace(/\s+/, '')[0] === '#') {
          linesComment.push(i);
        }
      });

      splitLines.forEach(function(line, i) {
        var lineContent = []
        var splitSegs = line.split(/(\s+)/).filter(Boolean);
        splitSegs.forEach(function(seg, j) {
          var className = 'code code-general';
          if (seg.indexOf(' ') !== -1) {
            seg = new Array(seg.length + 1).join(' ');
          } else if (i >= lineStartMethodBody && i <= lineEndMethodBody && linesComment.indexOf(i) === -1) {
            className += ' method-body-' + highlightBody ;
          }
          lineContent.push(<span key={ 'sol-' + solvedProb.id + '-line-' + i + '-seg-' + j } className={ className }>{ seg }</span>);
        });
        formattedSol.push(<span key={ 'sol-' + solvedProb.id + '-line-' + i }>{ lineContent }<br /></span>);
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
