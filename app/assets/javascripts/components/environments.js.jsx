/* globals React */
'use strict';

var Environments = React.createClass({
  getInitialState: function() {
    return {
      envIdProblemsShown: 0
    };
  },
  render: function() {
    var parent = this;
    var envIdProblemsShown = this.state.envIdProblemsShown;
    var envs = [];
    var environments = this.props.environments;
    environments.forEach(function(env) {
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
            }
            seg = seg.slice(1);
          }
          formattedLine.push(<span key={ 'env-' + env.id + '-seg-' + j } className={ className }>{ seg }</span>);
        });
        formattedDescrip.push(<p key={ 'env-' + env.id + '-line' + i }>{ formattedLine }</p>);
      });
      envs.push(
        <ModalEnvironment key={'env-' + env.id } environment={ env } descrip={ formattedDescrip } parent={ parent } showProblems={ env.id === envIdProblemsShown ? true : false } />
      );
    });

    return(
      <div className='environments'>
        { envs }
      </div>
    );
  }
});

