/*jshint bitwise:true, indent:2, curly:true, eqeqeq:true, immed:true,
latedef:true, newcap:true, noarg:true, regexp:true, undef:true,
trailing:true, white:true*/
/*global XT:true, XM:true, XV:true, _:true, window: true, enyo:true, nv:true, d3:true, console:true */

(function () {

  // TODO query filter on collection
  enyo.kind({
    name: "XV.IncidentBarChart",
    kind: "XV.BarChart",
    collection: "XM.IncidentListItemCollection",
    chartTitle: "_openIncidents".loc(),
    //drillDownAttr: "orderNumber",
    //drillDownRecordType: "XM.SalesOrderRelation",
    filterOptions: [
      { name: "all" },
      { name: "highPriority" }
    ],
    groupByOptions: [
      { name: "category" },
      { name: "assignedTo" },
      { name: "priority" }
    ],
    filterData: function (rawData) {
      var that = this;

      return _.filter(rawData, function (datum) {
        switch (that.getFilterField()) {
        case "all":
          return true;
        case "highPriority":
          return datum.priorityOrder + 1 < (XM.priorities.length / 2); // XXX hack
        }
      });
    }
  });

  enyo.kind({
    name: "XV.CrmDashboard",
    kind: "XV.Dashboard",
    components: [
      {kind: "XV.IncidentBarChart" }
    ]
  });

}());
