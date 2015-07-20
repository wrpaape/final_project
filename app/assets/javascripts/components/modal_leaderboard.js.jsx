/* globals React */
'use strict';

var ModalLeaderboard = React.createClass({

  render: function() {
    var rows = [];
    var solvedProbs = this.props.solvedProbs;
    var keys = Object.keys(solvedProbs[0]);
    solvedProbs.forEach(function(solvedProb, i){
      rows.push(<RowLeaderboard key={ 'row-leader-' + i } solvedProb={ solvedProb } />);
    });

    return(
      <div className={ this.props.className } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
        <div className='modal-dialog modal-lg'>
          <div className='modal-content image'>
            <section>
              <table>
                <TableHeadLeaderboard colNames={ keys } />
                <tbody>
                  { rows }
                </tbody>
              </table>
            </section>
          </div>
        </div>
      </div>
    );
  }
});
