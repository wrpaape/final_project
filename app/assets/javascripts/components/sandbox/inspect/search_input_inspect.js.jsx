/* globals React */
'use strict';

var SearchInputInspect = React.createClass({
  getInitialState: function() {
    return {
      value: this.props.defaultValue
    };
  },
  componentWillReceiveProps: function(nextProps) {
    console.log(this.props.defaultValue);
    this.setState({ value: this.props.defaultValue });
  },
  render: function() {
    var type = this.props.type;
    if (type === 'text'){
      return (
        <div>
          <input id={ this.props.id } className={ this.props.className } type={ type } value={ this.state.value } onChange={ this.changed } />
        </div>
      );
    } else {
      return (
        <div>
          <input id={ this.props.id } className={ this.props.className } type={ type } checked={ this.state.value } onChange={ this.checked } />
        </div>
      );
    }
  },
  changed: function (e) {
    this.setState({ value: e.target.value });
  },
  checked: function () {
    var newValue = this.state.value === 'on' ? '' : 'on';
    console.log(this.state.value);
    console.log(newValue);
    this.setState({ value: newValue });
  }
});
