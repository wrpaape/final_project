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
    var dataTypes = [];
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table interact lighten-' + this.state.loading;

    data.forEach(function (obj) {
      dataTypes.push(typeof(obj));
    });
    var areSameType = dataTypes.reduce(function(a, b){return (a === b) ? a : false;});

    if (areSameType && data[0].id !== undefined) {
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
    } else {
      data.forEach(function (obj, i) {
        rows.push(<tr key={ 'misc-' + i }>{ JSON.stringify(obj) }</tr>);
      });
      return(
        <div className='container-interact'>
          <section>
            <img src='/assets/pig_glow.gif' className={ loadingClassName } />
            { rows }
          </section>
          <EditorInteract parent={ this } />
        </div>
      );
    }
  }
});
