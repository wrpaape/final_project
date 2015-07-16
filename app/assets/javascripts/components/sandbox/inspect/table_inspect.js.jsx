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
    var rows = [];
    var data = this.state.data;
    var pageData = data.pageData;
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table inspect lighten-' + this.state.loading;

    pageData.forEach(function (obj) {
      rows.push(<RowInspect key={ 'row-' + obj.id } obj={ obj } url={ data.url + obj.id } parent={ this } />);
    }.bind(this));
    var styles = {
      paddingRight: this.state.padding + 'px'
    };

    return(
      <div className='container-inspect' style={ styles }>
        <div className='container-table'>
          <section>
            <table className={ tableClassName }>
              <img src='/assets/pig_glow.gif' className={ loadingClassName } />
              <TableHeadInspect parent={ this } />
              <tbody>
                {rows}
              </tbody>
            </table>
          </section>
          <div className='sticky-footer paginate'>
            <PaginateInspect parent={ this } />
            <LimitBarInspect parent={ this} />
            <QueryInspect parent={ this } />
          </div>
        </div>
        <WindowInspect parent={ this } />
      </div>
    );
  }
});
