/* globals React */
'use strict';

var ModalEnvironment = React.createClass({
  getInitialState: function() {
    return {
      hovered: this.props.hovered,
      showProblems: false
    };
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({
      hovered: nextProps.hovered,
      showProblems: false
    });
  },
  render: function() {
    var probButtons = [];
    var hovered = this.state.hovered;
    var showProblems = this.state.showProblems;
    var environment = this.props.environment;
    var env = environment.env;
    var probs = environment.probs;
    var title = this.props.title;
    var descrip = this.props.descrip;
    var umlFilePath = '/assets/environment' + env.id + '_uml.png';

    probs.forEach(function(prob, i) {
      probButtons.push(<div key={ prob.id }><a href={'/problems/' + prob.id } className='btn btn-default'>{ prob.title }</a></div>);
    });

    return(
      <div className='env-wrap' onMouseEnter={ this.mouseEnter }>
        <div className={ 'env-title ' + hovered }>
          { title }
        </div>
        <div className={ 'env-details ' + hovered } onMouseOut={ this.mouseOut }>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target={'.env-' + env.id }>
            description
          </button>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target={'.uml-' + env.id }>
            UML
          </button>
          <button className='btn btn-primary' onClick={ this.clicked }>
            problems
          </button>
          <br />
          <div className={ 'problems-wrap ' + showProblems }>
            { probButtons }
          </div>
          <div id={ 'fade-env-' + env.id } className={ 'modal fade env-' + env.id } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
            <div className='modal-dialog modal-lg'>
              <div className='modal-content'>
                { descrip }
              </div>
            </div>
          </div>
        <div className={ 'modal fade uml-' + env.id } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content image'>
              <Img src={ umlFilePath } className='image-uml'/>
            </div>
          </div>
        </div>
        </div>
      </div>
    );
  },
  mouseEnter: function() {
    var env = this.props.environment.env;
    var envIndex = this.props.parent;
    envIndex.setState({ envIdHovered: env.id });
  },
  clicked: function() {
    var oldShowProblems = this.state.showProblems;
    this.setState({ showProblems: !oldShowProblems });
  }
});
