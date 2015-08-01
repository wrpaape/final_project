/* globals React */
'use strict';

var TableInspect = React.createClass({
  getInitialState: function () {
    var initialModels = this.props.models;
    var initialModel = Object.keys(initialModels)[0];
    return {
      padding: 25,
      data: this.props.data,
      models: initialModels,
      currentModel: initialModel,
      wind0wObj: { id: 0 },
      wind0wObjModel: initialModel,
      limit: initialModels[initialModel].limit,
      offset: initialModels[initialModel].offset,
      search: initialModels[initialModel].search,
      sort: initialModels[initialModel].sort,
      caseSens: initialModels[initialModel].caseSens,
      fuzzy: initialModels[initialModel].fuzzy,
      loading: false
    };
  },
  render: function () {
    var switchTable = this.props.parent;
    var lastQuery = $('.colored-query-line');
    var data = this.state.data;
    var modelFile = data.modelFile;
    var migrationFile = data.migrationFile;
    var pageData = data.pageData;
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table inspect lighten-' + this.state.loading;

    var rows = [];
    pageData.forEach(function (obj) {
      rows.push(<RowInspect key={ 'row-' + obj.id } obj={ obj } url={ data.url + obj.id } grandparent={ switchTable } parent={ this } />);
    }.bind(this));
    var styles = {
      paddingRight: this.state.padding + 'px'
    };

    var padFile = function(file, type) {
      var paddedModelFile = [];
      var lines = file.split('\n');
      for (var i = 1; i <= lines.length - 1; i++) {
        var padIndex = lines[i].search(/[^~]/);
        var pad = new Array(padIndex + 1).join('~');
        var line = lines[i].slice(padIndex);
        var formattedLine = [];
        var splitLine = line.split('$');

        splitLine.forEach(function(seg, j) {
          var className = 'code ';
          if (j % 2 !== 0) {
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
          } else {
            className += 'code-general';
          }
          formattedLine.push(<span key={ 'file-seg-' + j } className={ className }>{ seg }</span>);
        });
        paddedModelFile.push(<span key={ type + '-line-' + i }><span className='pad'>{ pad }</span><span className={ type + '-line' }>{ formattedLine }</span><br /></span>);
      }
      return paddedModelFile;
    }

    return(
      <div className='container-inspect' style={ styles }>
        <div className='container-table'>
          <section className='inspect'>
            <table className={ tableClassName }>
              <Img src='/assets/pig_glow.gif' className={ loadingClassName } />
              <TableHeadInspect parent={ this } />
              <tbody>
                { rows }
              </tbody>
            </table>
          </section>
          <div className='sticky-footer paginate sticky-footer-inspect'>
            <PaginateInspect parent={ this } />
            <LimitBarInspect parent={ this} />
            <QueryInspect parent={ this } lastQuery={ lastQuery } />
          </div>
        </div>
        <WindowInspect grandparent={ switchTable } parent={ this } />
        <div className='modal fade model-file' tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content model'>
              { padFile(modelFile, 'model') }
            </div>
          </div>
        </div>
        <div className='modal fade migration-file' tabIndex='-1' role='dialog' aria-labelledby='myLargeModalLabel'>
          <div className='modal-dialog modal-lg'>
            <div className='modal-content migration'>
              { padFile(migrationFile, 'migration') }
            </div>
          </div>
        </div>
      </div>
    );
  }
});
