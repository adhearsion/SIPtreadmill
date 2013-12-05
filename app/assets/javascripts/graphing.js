function drawTotalCallsGraph(data, target) {
  nv.addGraph(function() {
    var chart = nv.models.stackedAreaChart()
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .color(['#55ff55','#ff2a2a', '#ffcc00'])
                  .clipEdge(true);

    chart.xAxis
          .axisLabel('Time')
          .tickFormat(function(d) { return d3.time.format('%X')(new Date(d)) });

    chart.yAxis
          .axisLabel('Number of Calls')
          .tickFormat(d3.format(',.0f'));

    d3.select(target + " svg")
          .datum(data).transition()
          .duration(500).call(chart);

    nv.utils.windowResize(chart.update);
    return chart;
  });
}

function drawRunsCompleted(data, target) {
  nv.addGraph(function() {
    var chart = nv.models.discreteBarChart()
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .showValues(true).color(['#1f77b4']);

    chart.xAxis
         .axisLabel('Date')
         .tickFormat(function(d) { return d3.time.format('%x')(new Date(d) )});

    chart.yAxis
         .axisLabel('Test Runs')
         .tickFormat(d3.format(',.0f'));

    d3.select(target + " svg")
         .datum(data).transition()
         .duration(500).call(chart);

    nv.utils.windowResize(chart.update);
    return chart;
  });
}

function drawLineGraph(data, options){
  nv.addGraph(function() {
    var chart = nv.models.lineChart()
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .clipEdge(true);

    chart.xAxis
         .axisLabel(options.xAxis)
         .tickFormat(function(d) { return d3.time.format('%X')(new Date(d) )});

    chart.yAxis
         .axisLabel(options.yAxis)
         .tickFormat(d3.format(',.2f'));

    d3.select(options.target + " svg")
          .datum(data).transition()
          .duration(500).call(chart);

    nv.utils.windowResize(chart.update);
    return chart;
  });
}
