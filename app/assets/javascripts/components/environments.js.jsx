/* globals React */
'use strict';

var Environments = React.createClass({
  getInitialState: function() {
    return {
      showInspect: true,
      showInteract: false,
      currentEnvironment: null
    };
  },
  render: function() {
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
        <div className='env-wrap' key={'env-' +env.id }>
          <button type='button' className='btn btn-primary' data-toggle='modal' data-target={'.env-' + env.id }>
            { env.title }
          </button>
          <div className={ 'modal fade env-' + env.id } tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
            <div className='modal-dialog modal-lg'>
              <div className='modal-content'>
                { formattedDescrip }
              </div>
            </div>
          </div>
        </div>
      );
    });

    return(
      <div className='environments'>
        { envs }
      </div>
    );
  },
  switched: function() {
    var newShowInspect = !this.state.showInspect;
    var newShowInteract = !this.state.showInteract;
    this.setState({
      showInspect: newShowInspect,
      showInteract: newShowInteract
    });
  }
});
