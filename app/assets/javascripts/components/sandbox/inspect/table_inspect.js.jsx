/* globals React */
'use strict';

var TableInspect = React.createClass({
  getInitialState: function () {
    return {
      data: this.props.data,
      models: this.props.models,
      currentModel: Object.keys(this.props.models)[0],
      windowObj: { id: 0 },
      loading: false
    };
  },
  render: function () {
    var rows = [];
    var data = this.state.data;
    var pageData = data.pageData;
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table lighten-' + this.state.loading;

    pageData.forEach(function (obj) {
      rows.push(<RowInspect key={ 'row-' + obj.id } obj={ obj } keys={ data.keys } url={ data.url + obj.id } parent={this} />);
    }.bind(this));

    return(
      <div className='row'>
        <div className='col-md-9'>
          <section>
            <table className={ tableClassName }>
              <img src='assets/pig_glow.gif' className={ loadingClassName } />
              <TableHeadInspect parent={ this } />
              <tbody>
                {rows}
              </tbody>
            </table>
          </section>
          <div className='row table-footer'>
            <div className='col-md-8'>
              <PaginateInspect parent={ this } />
            </div>
            <div className='col-md-4'>
              <LimitBarInspect parent={ this} />
            </div>
          </div>
        </div>
        <div className='col-md-3'>
          <div className='row'>
            <WindowInspect parent={ this } />
          </div>
        </div>
      </div>
    );
  }
});
