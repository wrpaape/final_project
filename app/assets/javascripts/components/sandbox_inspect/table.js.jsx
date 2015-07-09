/* globals React */
'use strict';

var Table = React.createClass({
  getInitialState: function () {
    return {
      data: this.props.data,
      limit: 10,
      offset: 0,
      search: '',
      sort: '',
      caseSens: 'false',
      fuzzy: 'true',
      windowObj: { id: 0 },
      loading: false
    };
  },
  render: function () {
    var rows = [];
    var data = this.state.data;
    var pageData = data.pageData;
    pageData.forEach(function (obj) {
      rows.push(<Row key={ 'row-' + obj.id } obj={ obj } keys={ data.keys } url={ data.url + obj.id } parent={this} />);
    }.bind(this));
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table lighten-' + this.state.loading;
    return(
      <div className='row'>
        <div className='col-md-9'>
          <section>
            <table className={ tableClassName }>
              <img src='assets/pig_glow.gif' className={ loadingClassName } />
              <TableHead parent={ this } />
              <tbody>
                {rows}
              </tbody>
            </table>
          </section>
          <div className='row table-footer'>
            <div className='col-md-8'>
              <Paginate parent={ this } />
            </div>
            <div className='col-md-4'>
              <LimitBar parent={ this} />
            </div>
          </div>
        </div>
        <div className='col-md-3'>
          <div className='row'>
            <Window parent={ this } />
          </div>
        </div>
      </div>
    );
  }
});
