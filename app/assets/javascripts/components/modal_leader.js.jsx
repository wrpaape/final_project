/* globals React */
'use strict';

var ModalLeader = React.createClass({

  render: function() {
    return(
      <div className={ this.props.className } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
        <div className='modal-dialog modal-lg'>
          <div className='modal-content'>
            LOLOL
          </div>
        </div>
      </div>
    );
  }
});
