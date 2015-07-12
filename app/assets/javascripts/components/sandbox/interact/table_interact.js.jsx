/* globals React */
'use strict';

var TableInteract = React.createClass({
  getInitialState: function () {
    return {
      data: this.props.data,
      loading: false
    };
  },
  render: function () {
    var rows = [];
    var data = this.state.data;
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table interact lighten-' + this.state.loading;

    data.forEach(function (obj) {
      rows.push(<RowInteract key={ 'row-' + obj.id } obj={ obj } url={ data.url + obj.id } parent={ this } />);
    }.bind(this));

    return(
      <div className='container-interact'>
        <section>
          <table className={ tableClassName }>
            <img src='/assets/pig_glow.gif' className={ loadingClassName } />
            <TableHeadInteract parent={ this } />
            <tbody>
              {rows}
            </tbody>
          </table>
        </section>
        <EditorInteract parent={ this } />
      </div>
    );
  }
});
