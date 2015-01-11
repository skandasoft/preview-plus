NeatComponent = React.createClass
  render: ->
    <div className="neat-component">
      {<h1>A Component is I</h1> if @props.showTitle}
      <hr />
      {<p>see whow printed This line has been printed {n} times</p> for n in [1..@props.n]}
      <ul>
        <li>line item 1</li>
        <li>line item 2</li>
      </ul>

    </div>
React.render <NeatComponent showTitle=true n=8 />, document.body
