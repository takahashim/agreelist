function drawOccupationsChart() {
  if(typeof google != 'undefined'){
    var data = google.visualization.arrayToDataTable(occupations);

    var view = new google.visualization.DataView(data);
    view.setColumns([0, 2]);

    var options = {
      title: 'Number of opinions by occupation'
    };

    var chart = new google.visualization.PieChart(
      document.getElementById('occupations_pie')
    );
    chart.draw(view, options);

    var selectHandler = function(e) {
      window.location = data.getValue(chart.getSelection()[0]['row'], 1 );
    }

    // Add our selection handler.
    google.visualization.events.addListener(chart, 'select', selectHandler);
  }
}

function drawSchoolsChart() {
  if(typeof google != 'undefined'){
    var data = google.visualization.arrayToDataTable(schools);

    var view = new google.visualization.DataView(data);
    view.setColumns([0, 2]);

    var options = {
      title: 'Number of opinions by where they studied'
    };

    var chart = new google.visualization.PieChart(
      document.getElementById('schools_pie')
    );
    chart.draw(view, options);

    var selectHandler = function(e) {
      window.location = data.getValue(chart.getSelection()[0]['row'], 1 );
    }

    // Add our selection handler.
    google.visualization.events.addListener(chart, 'select', selectHandler);
  }
}
