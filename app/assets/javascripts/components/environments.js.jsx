/* globals React */
'use strict';

var Environments = React.createClass({
  getInitialState: function() {
    return {
      envIdHovered: 0,
      showEnvs: false,
      showDocs: false
    };
  },
  componentDidMount: function() {
    $('#page-cover').removeClass('cursor-progress');
  },
  render: function() {
    var parent = this;
    var envIdHovered = this.state.envIdHovered;
    var showEnvs = this.state.showEnvs;
    var showDocs = this.state.showDocs;
    var selectEnvClass = 'btn btn-primary show-envs-' + showEnvs;
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
        if (line.length === 0) {
          line = ' ';
        }
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
        <div key={ 'env-' + env.id } onMouseLeave={ parent.mouseLeave } >
          <ModalEnvironment environment={ environment } title={ formattedTitle } descrip={ formattedDescrip } parent={ parent } hovered={ env.id === envIdHovered ? true : false } />
        </div>
      );
    });
    var arDocs = {
      'basics': 'http://guides.rubyonrails.org/active_record_basics.html',
      'migrations': 'http://guides.rubyonrails.org/active_record_migrations.html',
      'validations': 'http://guides.rubyonrails.org/active_record_validations.html',
      'callbacks': 'http://guides.rubyonrails.org/active_record_callbacks.html',
      'associations': 'http://guides.rubyonrails.org/association_basics.html',
      'query interface': 'http://guides.rubyonrails.org/active_record_querying.html'
    }
    var docs = [];
    Object.keys(arDocs).forEach(function(doc) {
      docs.push(<a key={ doc } href={ arDocs[doc] } target='_blank' className='btn btn-primary ar-docs'>{ doc }</a>);
    });

    return(
      <div>
        <div className='env-index'>
          <div className='root-buttons-wrap'>
            <a href='/' className='btn btn-primary home'>
              home
            </a>
            <div className={ selectEnvClass } onClick={ this.toggleEnvs }>
              <span className='code code-sql'>SELECT</span><span>&nbsp;your&nbsp;</span><span className='code code-ar-keyword'>environment</span>
            </div>
            <div className='btn btn-primary ar-docs' onClick={ this.toggleDocs }>
              <span className='code code-ar-keyword'>ActiveRecord </span><span>docs</span>
            </div>
          </div>
          <div className={ 'envs-wrap ' + showEnvs }>
            { envs }
          </div>
        </div>
        <div className={ 'docs-wrap ' + showDocs }>
          { docs }
        </div>
      </div>
    );
  },
  mouseLeave: function() {
    this.setState({ envIdHovered: 0 });
  },
  toggleEnvs: function() {
    var showEnvs = this.state.showEnvs;
    this.setState({ showEnvs: !showEnvs });
  },
  toggleDocs: function() {
    var showDocs = this.state.showDocs;
    this.setState({ showDocs: !showDocs });
  }
});

