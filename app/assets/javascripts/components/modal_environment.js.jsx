/* globals React */
'use strict';

var ModalEnvironment = React.createClass({
  getInitialState: function() {
    return {
      showProblems: this.props.showProblems
    };
  },
  render: function() {
    var env = this.props.environment;
    var descrip = this.props.descrip;


    return(
      <div className='env-wrap'>
        <div>
          { env.title }
        </div>
        <button type='button' className='btn btn-primary' data-toggle='modal' data-target={'.env-' + env.id }>
          description
        </button>
        <div className='btn btn-primary' onClick={ this.clicked }>
          problems
        </div>
        <div id={ 'fade-env-' + env.id } className={ 'modal fade env-' + env.id } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content'>
              { descrip }
            </div>
          </div>
        </div>
      </div>
    );
  },
  clicked: function() {
    var env = this.props.environment;
    var envIndex = this.props.parent;
    envIndex.setState({ envIdProblemsShown: env.id });
  }
});
