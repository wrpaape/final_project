/* globals React */
'use strict';

var Environments = React.createClass({
  getInitialState: function() {
    return {
      envIdHovered: 0,
      showEnvs: false
    };
  },
  render: function() {
    var parent = this;
    var envIdHovered = this.state.envIdHovered;
    var showEnvs = this.state.showEnvs;
    var envs = [];
    var environments = this.props.environments;
    environments.forEach(function(environment) {
      var formattedTitle = [];
      var env = environment.env;
      var splitLine = env.title.split('|');
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
        formattedTitle.push(<span key={ 'env-' + env.id + '-title-seg-' + j } className={ className }>{ seg }</span>);
      });
      var formattedDescrip = [];
      var descrip = env.description.split('\n');
      descrip.forEach(function(line, i) {
        var splitLine = line.split('|');
        var formattedLine = [];
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
          formattedLine.push(<span key={ 'env-' + env.id + '-descrip-seg-' + j } className={ className }>{ seg }</span>);
        });
        formattedDescrip.push(<p key={ 'env-' + env.id + '-descrip-line' + i }>{ formattedLine }</p>);
      });
      envs.push(
        <div key={'env-' + env.id } onMouseLeave={ parent.mouseLeave } >
          <ModalEnvironment environment={ environment } title={ formattedTitle } descrip={ formattedDescrip } parent={ parent } hovered={ env.id === envIdHovered ? true : false } />
        </div>
      );
    });

    return(
      <div className='env-index'>
        <div onClick={ this.clicked }>
          <div className='btn btn-primary'>
            <span className='code code-sql'>SELECT</span><span>&nbsp;your&nbsp;</span><span className='code code-ar-keyword'>environment</span>
          </div>
        </div>
        <div className={ 'envs-wrap ' + showEnvs }>
          { envs }
        </div>
      </div>
    );
  },
  mouseLeave: function() {
    this.setState({ envIdHovered: 0 });
  },
  clicked: function() {
    var showEnvs = this.state.showEnvs;
    this.setState({ showEnvs: !showEnvs });
  }
});

