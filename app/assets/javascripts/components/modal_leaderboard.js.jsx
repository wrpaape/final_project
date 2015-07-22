/* globals React */
'use strict';

var ModalLeaderboard = React.createClass({

  render: function() {
    var rows = [];
    var solvedProbs = this.props.solvedProbs;
    var probId = this.props.probId;
    solvedProbs.forEach(function(solvedProb, i){
      rows.push(<RowLeaderboard key={ 'row-leader-' + i } row={ i } probId={ probId } solvedProb={ solvedProb } />);
    });

    return(
      <div className={ this.props.className } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
        <div className='modal-dialog modal-lg'>
          <div className='modal-content image'>
            <section className='leader-section'>
              <table className='leader-root-table'>
                <TableHeadLeaderboard />
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
