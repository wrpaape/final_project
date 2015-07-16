/* globals React */
'use strict';

var ModelMigrationInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var data = table.state.data;
    var migrationFileName = data.migrationFileName;

    var paddedMigrationFile = padMigrationFile(migrationFile);

    if (show) {
      return(
        <div>
          <div data-id={ show } onClick={ this.clicked.bind(this, show) } className='wind0w-button btn btn-default show-hide'>
            { migrationFileName }
          </div>
          <section className='migration'>
            { paddedMigrationFile }
          </section>
        </div>
      );
    } else {
      return(
        <div data-id={ show } onClick={ this.clicked.bind(this, show) } className='wind0w-button btn btn-primary show-hide'>
          Migration
        </div>
      );
    };
    function padMigrationFile(migrationFile) {
      var paddedMigrationFile = [];
      var lines = migrationFile.split('\n');
      for (var i = 1; i <= lines.length - 1; i++) {
        var padIndex = lines[i].search(/[a-z]/);
        var pad = new Array(padIndex + 1).join('~');
        var line = lines[i].slice(padIndex);
        paddedMigrationFile.push(<span key={ 'migration-line-' + i }><span className='pad'>{ pad }</span><span className='migration-line'>{ line }</span><br /></span>);
      }
      return paddedMigrationFile;
    }
  },
  clicked: function(show) {
    this.setState({ show: !show });
  }
});
