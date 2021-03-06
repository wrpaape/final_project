/* globals React */
'use strict';

var ModalEnvironment = React.createClass({
  getInitialState: function() {
    return {
      hovered: this.props.hovered,
      showProbs: false
    };
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({
      hovered: nextProps.hovered,
      showProbs: false
    });
  },
  render: function() {
    var probButtons = [];
    var leaderButtons = [];
    var leaderModals = [];
    var hovered = this.state.hovered;
    var showProbs = this.state.showProbs;
    var environment = this.props.environment;
    var env = environment.env;
    var probs = environment.probs;
    var title = this.props.title;
    var descrip = this.props.descrip;
    var umlFilePath = '/assets/environment' + env.id + '_uml.png';

    probs.forEach(function(probHash, i) {
      var prob = probHash.prob;
      var solvedProbs = probHash.solvedProbs;
      var formattedTitle = [];
      var splitLine = prob.title.split('|');
      splitLine.forEach(function(seg, j) {
        var className = '';
        if (j % 2 !== 0) {
          className += 'code ';
          if (seg[0] === '%') {
            className += 'code-general';
          } else if (seg[0] === '?') {
            className += ' code-sql';
          } else if (seg[0] === '#') {
            className += ' code-ar-keyword';
          } else if (seg[0] === '@') {
            className += ' code-table';
          } else if (seg[0] === '&') {
            className += ' code-relation';
          } else if (seg[0] === '*') {
            className += ' code-attribute';
          } else if (seg[0] === '~') {
            className += ' code-model';
          } else if (seg[0] === '`') {
            className += ' code-value';
          }
          seg = seg.slice(1);
        }
        formattedTitle.push(<span key={ 'prob-' + prob.id + '-title-seg-' + j } className={ className }>{ seg }</span>);
      });
      probButtons.push(<div key={ prob.id }><a href={'/problems/' + prob.id } className='btn btn-primary'>{ formattedTitle }</a></div>);
      leaderButtons.push(<div key={ 'leader-' + prob.id }><button type='button' className='btn btn-default' data-toggle='modal' data-target={'.leader-' + prob.id }>leaderboard</button></div>);
      leaderModals.push(<ModalLeaderboard key={ 'modal-leader-' + prob.id } className={ 'modal fade leader-' + prob.id } probId={ prob.id } solvedProbs={ solvedProbs } />);
    });

    return(
      <div className='env-wrap' onMouseEnter={ this.mouseEnter }>
        <div className={ 'env-title ' + hovered }>
          { title }
        </div>
        <div className={ 'env-details ' + hovered } onMouseOut={ this.mouseOut }>
          <button className='btn btn-default' onClick={ this.clicked }>
            problems
          </button>
          <button id={ 'env-' + env.id +'-descrip'  } type='button' className={ 'btn btn-default glow1 env-descrip' } onClick={ this.extinguish } data-toggle='modal' data-target={'.env-' + env.id }>
            description
          </button>
          <button type='button' className='btn btn-default' data-toggle='modal' data-target={'.uml-' + env.id } onClick={ this.ensureShow }>
            UML
          </button>
          <br />
          <div className={ 'problems-leaders-wrap ' + showProbs }>
            <div className='problems-wrap '>
              { probButtons }
            </div>
            <div className='leaders-wrap '>
              { leaderButtons }
            </div>
          </div>
        </div>
        <div id={ 'modal-env-' + env.id + '-descip'} className={ 'modal fade env-' + env.id } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content'>
              { descrip }
            </div>
          </div>
        </div>
        <div id={ 'modal-env-' + env.id + '-uml'} className={ 'modal fade uml-' + env.id } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content image'>
              <Img src={ umlFilePath } className='image-uml'/>
            </div>
          </div>
        </div>
        { leaderModals }
      </div>
    );
  },
  mouseEnter: function() {
    var env = this.props.environment.env;
    var envIndex = this.props.parent;
    envIndex.setState({ envIdHovered: env.id });
  },
  clicked: function() {
    var oldShowProbs = this.state.showProbs;
    this.setState({ showProbs: !oldShowProbs });
  },
  extinguish: function() {
    var env = this.props.environment.env;
    $('button#env-' + env.id + '-descrip').removeClass('glow1');
  }
});
